require 'rails/generators'
require 'rails/generators/active_record'

module InhouseEvents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      desc 'Create an initializer and routing for InhouseEvents.'

      def create_configuration
        template 'inhouse_events.rb', 'config/initializers/inhouse_events.rb'
      end

      def require_inhouse_events_js
        inject_into_file 'app/assets/javascripts/application.js',
                         before: "//= require_tree .\n" do
          <<-"JS"
//= require inhouse_events
        JS
        end
      end

      def add_routes
        route 'mount InhouseEvents::Engine, at: "/inhouse_events"'
      end

      def create_events_table_migration
        migration_template('inhouse_events_migration.rb.erb',
                           'db/migrate/create_inhouse_events.rb')
      end
    end
  end
end
