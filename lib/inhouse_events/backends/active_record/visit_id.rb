require 'active_record'

module InhouseEvents
  module Backends
    class ActiveRecord
      # Construcs visit_id metric according to events database table and
      # session_id.
      class VisitId
        def compute(session_id)
          previous_event = session_id.nil? ? nil : latest_event(session_id)
          previous_event.nil? ? SecureRandom.uuid : previous_event.visit_id
        end

        def latest_event(session_id)
          ::InhouseEvents::Backends::ActiveRecord::Event
            .where('server_timestamp > ?', Time.now - 30.minutes)
            .where(session_id: session_id)
            .order(server_timestamp: :desc)
            .first
        end
      end
    end
  end
end
