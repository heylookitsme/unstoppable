require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Unstoppable
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true


    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins  'http://localhost:3000', 'http://shardax-unstoppable-ui.netlify.app'
        resource '*', headers: :any, methods: [:get, :post, :delete, :patch, :options], credentials: true
      end
    end

  end
end
