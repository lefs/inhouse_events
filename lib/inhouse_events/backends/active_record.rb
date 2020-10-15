require 'active_record'
require 'inhouse_events/backends/active_record/visit_id'

module InhouseEvents
  module Backends
    # A backend for InhouseEvents that saves events as rows in a database table
    # using ActiveRecord.
    class ActiveRecord
      class Event < ::ActiveRecord::Base
        self.table_name = 'inhouse_events'
      end

      def publish(e)
        e[:visit_id] = InhouseEvents::Backends::ActiveRecord::VisitId
                       .new.compute(e[:session_id])
        event = ::InhouseEvents::Event.new(e)
        publish_event(event)
      end

      def verify_credentials; end

      private

      def publish_event(event)
        Event.create!(event.payload)
      end
    end
  end
end
