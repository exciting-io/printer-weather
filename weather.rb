require "wunderground"
require "active_support/time"

# 85f361b799a8c68c

class Weather
  def self.wunderground
    @wunderground ||= Wunderground.new(ENV["WUNDERGROUND_API_KEY"])
  end

  def self.location_and_timezone(ip)
    data = wunderground.get_geolookup_for(geo_ip: ip)
    {lat: data["location"]["lat"], lon: data["location"]["lon"], timezone: data["location"]["tz_long"]}
  end

  def initialize(job)
    Time.zone = ActiveSupport::TimeZone[job.timezone]
    @hours = extract_hourly_forecast(job)
    fill_in_data_with_history_if_required(@hours, job)
  end

  def forecast
    {day_for: Date::DAYNAMES[Date.today.wday],
     morning: summary_for_hours(8..11),
     lunch: summary_for_hours(12..14),
     afternoon: summary_for_hours(15..18),
     evening: summary_for_hours(19..23)}
  end

  private

  def extract_hourly_forecast(job)
    data = self.class.wunderground.get_hourly_for("#{job.lat},#{job.lon}")
    data["hourly_forecast"].inject({}) do |h, t| 
      time = Time.zone.at(t["FCTTIME"]["epoch"].to_i)
      if time >= start_time && time <= end_time
        h.merge({time => {
          temp: t["temp"]["metric"],
          condition: t["icon"]
        }})
      else
        h
      end
    end
  end

  def fill_in_data_with_history_if_required(data, job)
    if data.first.first > start_time
      earlier_data = self.class.wunderground.send(:"get_history_#{start_time.strftime("%Y%m%d")}_for", "#{job.lat},#{job.lon}")
      history_hours = earlier_data["history"]["observations"].inject({}) do |h, t|
        if t["utcdate"]["min"] == "20"
          time = Time.zone.parse(t["utcdate"]["pretty"]) - (20*60)
          h.merge({time => {
            temp: t["tempm"],
            condition: t["icon"]
          }})
        else
          h
        end
      end
      data.merge!(history_hours)
    end
  end

  def start_time
    Time.zone.now.beginning_of_day
  end

  def end_time
    @end_time ||= (start_time + 24.hours - 1.second)
  end

  def weather_for_hours(range)
    @hours.select { |t| range.include?(t.hour) }
  end

  def average_temp(hours)
    hours.inject(0) { |a, (t,f)| a + f[:temp].to_i } / hours.length
  end

  def average_symbol(hours)
    counts = hours.map { |t,f| f[:condition] }.inject({}) { |h,c| h[c] ||= 0; h[c] += 1; h }.invert
    counts[counts.keys.max]
  end

  def summary_for_hours(range)
    hours = weather_for_hours(range)
    temp = average_temp(hours)
    symbol = average_symbol(hours)
    {temperature: temp, symbol: symbol}
  end
end