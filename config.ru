# This file is used by Rack-based servers to start the application.

# Load up all the config vars using dontenv if we're not in production
unless ENV['RACK_ENV'] == 'production'
  require 'dotenv'
  Dotenv.load
end

# Add Cors support for the API
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any
  end
end


require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Deflater
run Rails.application
