# Teaspoon tries to load Rails before all the teaspoon_env.rb and other things.
# Set the test Rails engine as early as we can.
ENV['TEASPOON_RAILS_ENV'] = File.expand_path('spec/internal/config/environment',
                                             Dir.pwd)

require 'bundler/gem_tasks'
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) { |t| t.verbose = false }
  task default: :test
  task test: [:spec, :teaspoon]
rescue LoadError
  # No RSpec available.
end

desc 'Starts irb with inhouse_events loaded'
task :console do
  exec 'irb -r rails -r inhouse_events -I ./lib'
end

require 'action_view/railtie'
require 'jquery/rails'
require 'combustion'
require 'teaspoon'
require 'teaspoon-jasmine'

Combustion.initialize! :sprockets
Combustion::Application.load_tasks

APP_RAKEFILE = File.expand_path('../spec/internal/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'
