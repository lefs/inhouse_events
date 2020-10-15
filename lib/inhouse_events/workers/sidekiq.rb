require 'sidekiq'
require 'inhouse_events/workers/base'

module InhouseEvents
  module Workers
    class Sidekiq
      include ::Sidekiq::Worker
      include InhouseEvents::Workers::Base

      def self.handle_event(e)
        new.perform_async(e)
      end
    end
  end
end
