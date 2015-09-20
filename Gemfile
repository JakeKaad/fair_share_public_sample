source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'devise'
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'bootstrap_form'
gem 'mailgun-ruby', '~>1.0.3', require: 'mailgun'
gem 'puma'
gem 'simple_form'
gem 'validates_timeliness', '~> 3.0'
gem 'sidekiq'
gem 'sinatra', require: nil

group :development do
  gem 'byebug'
  gem 'web-console'
  gem 'spring'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'launchy'
  gem 'pry'
  gem 'dotenv'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'vcr'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

group :product do
  gem 'rails_12factor'
end
