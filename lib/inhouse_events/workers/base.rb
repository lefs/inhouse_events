module InhouseEvents
  module Workers
    module Base
      def perform(event)
        InhouseEvents.publish(event)
      end

      def handle_event
        raise 'Not Implemented Error'
      end
    end
  end
end
