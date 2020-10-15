require 'shared_examples/workers'
require 'inhouse_events/workers/inline'

module InhouseEvents
  module Workers
    describe Inline do
      it_behaves_like 'a worker'
    end
  end
end
