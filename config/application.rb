require File.expand_path('../boot', __FILE__)
require File.dirname(__FILE__) + '/../lib/params_parser_with_ignore.rb'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Emotejiji
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Middleware hack to prevent ActionDispatch ParamsParser from hijack grape post body queries
    config.middleware.swap ActionDispatch::ParamsParser, MyApp::ParamsParser, :ignore_prefix => '/api'

    # Change Schema Format to sql due to using postgres specific uuid
    config.active_record.schema_format = :sql

    # Add in Grape path
    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]

    # Minitest spec generators
    config.generators do |g|
      g.test_framework :mini_test, spec: true, fixture: false
    end
  end
end
