source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"
gem 'bootstrap-sass', '~> 3.4.1'
gem "font-awesome-sass", "~> 6.1"

# Foreman to run multiple processes
gem 'foreman'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Devise for user authentication management
# https://github.com/heartcombo/devise
gem "devise"
gem "devise-i18n"
gem "omniauth"
gem "omniauth-google-oauth2" # Login with Google
gem "omniauth-rails_csrf_protection"

# Prevents brute force attacks
gem 'rack-attack'

# Geocoder is a complete Ruby geocoding solution
# https://github.com/alexreisner/geocoder
gem "geocoder"
gem 'country_select', '~> 8.0'

# Create beautiful static maps with one line of Ruby. No more fighting with mapping libraries!
# See https://github.com/ankane/mapkick-static
gem "mapkick-static"

# Better forms for Ruby
# https://github.com/heartcombo/simple_form
gem "simple_form", github: "heartcombo/simple_form"

# Solution to generate fake data for db seeding (development)
# https://github.com/faker-ruby/faker
gem "faker"

# Gem used to query web services and examine the resulting output
# https://github.com/jnunemaker/httparty
gem 'httparty', '~> 0.21.0'

# Gems to process json files
gem 'json'

# Gem to strip attributes and keep data clean
# https://github.com/rmm5t/strip_attributes
gem "strip_attributes"

# Production-ready gems
gem 'bundler', '~> 2.4', '>= 2.4.12'
gem 'bundler-audit', '~> 0.9.1'

# Gem to enhance translations
# https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 7.0.0'

# Gems required for deployment on fly.io
gem "dockerfile-rails", ">= 1.5", :group => :development
gem "sentry-ruby", "~> 5.11"
gem "sentry-rails", "~> 5.11"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem 'rubocop', require: true
  gem 'erb-formatter'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Brakeman is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  gem 'brakeman'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'bullet'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
