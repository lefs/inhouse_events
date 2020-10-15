require 'active_job'
require 'inhouse_events/workers/base'

module InhouseEvents
  module Workers
    class ActiveJob < ::ActiveJob::Base
      include InhouseEvents::Workers::Base

      def self.handle_event(e)
        perform_later(e)
      end
    end
  end
end
