require 'spec_helper'
require 'support/generator_spec_helpers'
require 'ammeter/rspec/generator/example.rb'
require 'ammeter/rspec/generator/matchers.rb'
require 'ammeter/init'
require 'generators/inhouse_events/install/install_generator'

module InhouseEvents::Generators
  describe InstallGenerator, type: :generator do
    include GeneratorSpecHelpers
    destination File.expand_path('../../../../support/tmp', __FILE__)

    before do
      prepare_destination
      provide_application_js_file
      provide_routes_file
      run_generator
    end

    it 'creates an inhouse_events initializer' do
      initializer = file('config/initializers/inhouse_events.rb')

      expect(initializer).to exist
      expect(initializer).to have_correct_syntax
      expect(initializer).to contain('InhouseEvents.configure do |config|')
    end

    it 'includes the inhouse_events JavaScript file in application.js' do
      application_js = file('app/assets/javascripts/application.js')

      expect(application_js).to contain('//= require inhouse_events')
    end

    it 'adds inhouse_events routes to host application routes' do
      routes = file('config/routes.rb')

      expect(routes).to have_correct_syntax
      expect(routes).to contain('mount InhouseEvents::Engine, at: "/inhouse_events"')
    end

    describe 'ActiveRecord migration' do
      it 'creates a migration for the events table' do
        migration = migration_file('db/migrate/create_inhouse_events.rb')
        expect(migration).to exist
        expect(migration).to have_correct_syntax
        if Rails::VERSION::MAJOR == 5
          version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
          expect(migration).to contain(
            "class CreateInhouseEvents < ActiveRecord::Migration[#{version}]"
          )
        else
          expect(migration).to contain(
            'class CreateInhouseEvents < ActiveRecord::Migration'
          )
        end
        expect(migration).to contain('create_table :inhouse_events')
      end
    end
  end
end
