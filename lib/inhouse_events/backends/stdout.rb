module InhouseEvents
  module Backends
    class Stdout
      def publish(e)
        event = ::InhouseEvents::Event.new(e)
        puts event.to_json
      end

      def verify_credentials
        true
      end
    end
  end
end
