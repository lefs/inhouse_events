source 'https://rubygems.org'

# Specify your gem's dependencies in inhouse_events.gemspec
gemspec

group :test do
  gem 'actionpack'
  gem 'sqlite3', '~> 1.3.13'
  # CoffeeScript appears to be a secret dependency of Teaspoon:
  #   https://github.com/jejacks0n/teaspoon/issues/405
  gem 'coffee-script', '~> 2.4.1'
  gem 'jquery-rails'
  gem 'sprockets', '~> 3.0'
end

group :development, :test do
  gem 'byebug', '~> 9.0', '>= 9.0.6'
end
