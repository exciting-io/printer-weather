require "data_mapper"

DataMapper::setup(:default, ENV['SHARED_DATABASE_URL'] || "postgres://localhost/printer-weather")

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