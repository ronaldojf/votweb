require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Votweb
  class Application < Rails::Application
    # Do not generate specs for views and requests. Also, do not generate assets.
    config.generators do |g|
      g.helper false
      g.view_specs false
      g.assets false
      g.integration_tool false
    end
    config.app_generators do |g|
      g.test_framework :rspec
    end

    # Prevent initializing your application and connect to the database on assets precompile.
    config.assets.initialize_on_precompile = false

    config.time_zone = ENV.fetch('TZ', 'Brasilia')

    config.middleware.use Rack::Deflater

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
