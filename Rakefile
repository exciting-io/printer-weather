task :run do
  $LOAD_PATH.unshift "."
  require "job"
  require "net/http"
  require "uri"
  Job.each do |j|
    Net::HTTP.post_form(URI.parse(j.print_url), url: "http://printer-weather.herokuapp.com/weather/#{j.id}")
  end
end