# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.2.0', require: false
gem 'mini_magick', '~> 4.8'
gem 'pg', '>= 0.18'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'

gem 'acts_as_api'
gem 'bcrypt', '~> 3.1.7'
gem 'consul'
gem 'email_validator'
gem 'jwt'
gem 'kaminari'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'ransack'
gem 'redis', '~> 4.0'

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false

  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers'
end
