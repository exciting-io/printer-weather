require "rubygems"
require "bundler/setup"
require "sinatra"

$LOAD_PATH.unshift "."
require "weather"
require "job"

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