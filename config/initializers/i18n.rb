# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml")]

# Permitted locales available for the application
I18n.available_locales = %i[en de fr it]

# Set default locale to something other than :en
I18n.default_locale = :it

# Enable locale fallbacks for I18n.default_locale when a translation can not be found
# I18n.fallbacks = true
