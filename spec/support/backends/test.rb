module InhouseEvents
  module Backends
    class Test
      def initialize
        @captured_events = StringIO.new
      end

      def publish(event)
        @captured_events.write(event.to_json)
      end

      def published_events
        @captured_events.rewind
        @captured_events.read
      end

      def verify_credentials
        true
      end
    end
  end
end
