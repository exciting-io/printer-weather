require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift(".")
require "app"
require 'sass/plugin/rack'

Sass::Plugin.options[:template_location] = 'public/stylesheets'
use Sass::Plugin::Rack

run Sinatra::Application