require 'shared_examples/workers'
require 'inhouse_events/workers/sucker_punch'

module InhouseEvents
  module Workers
    describe SuckerPunch do
      it_behaves_like 'a worker'
    end
  end
end
