require "rubygems"
require "bundler/setup"
require "sinatra"
require "data_mapper"

$LOAD_PATH.unshift "."
require "weather"

DataMapper::setup(:default, ENV['SHARED_DATABASE_URL'] || "sqlite3://#{Dir.pwd}/printer-weather.db")

class Job
  include DataMapper::Resource
  property :id, Serial
  property :print_url, String, length: 255
  property :lat, String
  property :lon, String
  property :timezone, String
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Job.auto_upgrade!

get "/" do
  erb :index
end

get "/register" do
  erb :register
end

post "/register" do
  @job = Job.create!(params[:job].merge(Weather.location_and_timezone(request.ip)))
  erb :registered
end

get "/weather/:job_id" do
  job = Job.get(params[:job_id])
  @forecast = Weather.new(job).forecast
  erb :weather
end