require 'inhouse_events/workers/base'

module InhouseEvents
  module Workers
    class Inline
      include InhouseEvents::Workers::Base

      def self.handle_event(e)
        new.perform(e)
      end
    end
  end
end
