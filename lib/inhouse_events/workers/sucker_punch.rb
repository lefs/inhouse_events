require 'sucker_punch'
require 'inhouse_events/workers/base'

module InhouseEvents
  module Workers
    class SuckerPunch
      include ::SuckerPunch::Job
      include InhouseEvents::Workers::Base

      def self.handle_event(e)
        new.async.perform(e)
      end
    end
  end
end
