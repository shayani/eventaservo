require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eventaservo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'UTC'

    config.i18n.default_locale = :epo
    config.exceptions_app = self.routes

    config.active_job.queue_adapter = :delayed_job

    config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }
  end
end
