# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use Puma as the app server
gem 'puma', '~> 5.0.0.beta1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'webpacker', '~> 5.0'

gem 'acts-as-taggable-on', '~> 6.5'

gem 'bootstrap', '~> 4.3'
gem 'font-awesome-sass', '~> 5'
gem 'haml', '~> 5'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'
gem 'mini_racer', '~> 0.2'

gem 'select2-rails', '~> 4.0'

# Kalendaroj
gem 'fullcalendar-rails', '~> 3.9'
gem 'icalendar', '~> 2.6'
gem 'momentjs-rails', '~> 2.20'

gem 'mini_magick', '~> 4.10'
gem 'omniauth-facebook', '~> 6.0'

# CSS kaj fasonado
gem 'flag-icons-rails', '~> 3.4'

gem 'devise', '>= 4.7.1'
gem 'pg', '~> 1.1', '>= 1.1.3'
gem 'simple_token_authentication', '~> 1.0'
gem 'social-share-button', git: 'https://github.com/shayani/social-share-button'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'daemons', '~> 1.3'
gem 'delayed_job_active_record', '~> 4.1'
gem 'delayed_job_web'

gem 'rack-attack', '~> 6.2'
gem 'rack-cors', '~> 1.1', require: 'rack/cors'

gem 'browser', '~> 5.0'
gem 'diffy', '~> 3.3'
gem 'geocoder', '~> 1.6'
gem 'highcharts-rails', '~> 6.0'
gem 'hirb'
gem 'image_processing', '~> 1.2'
gem 'invisible_captcha', '~> 1.0'
gem 'leaflet-rails', '~> 1.7.0'
gem 'pagy', '~> 3.9'
gem 'paper_trail', '~> 10.3'
gem 'paper_trail-association_tracking', '~> 2.0'
gem 'premailer-rails', '~> 1.11'
gem 'redcarpet', '~> 3.5'
gem 'redis', '~> 4.1'
gem 'sentry-raven', '~> 3.0'
gem 'sitemap_generator', '~> 6.1'
gem 'timezone', '~> 1.0'
# gem 'trix-rails', require: 'trix'
gem 'httparty', '~> 0.18'
gem 'nokogiri', '>= 1.10.4'
gem 'yard'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
  gem 'rake'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  # RailsPanel Chrome Extension
  gem 'meta_request'
  gem 'seed_dump' # Por rekrei la seeds.db dosieron

  # Capistrano gems
  gem 'bcrypt_pbkdf'
  gem 'capistrano', '~> 3.14.1', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', require: false
  gem 'ed25519'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
