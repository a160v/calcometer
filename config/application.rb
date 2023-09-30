require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Calcometer
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Enable query encryption
    config.active_record.encryption.extend_queries = true
    config.active_record.encryption.support_unencrypted_data = true # required for devise to work

    # Where the I18n library should search for translation files
    I18n.load_path += Dir[Rails.root.join('lib', 'locales', '*.{rb,yml}')]

    # Permitted locales available for the application
    I18n.available_locales =  %i[it de en fr]

    # Set default locale to Italian
    I18n.default_locale = :it

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << Rails.root.join('app/services')
  end
end
