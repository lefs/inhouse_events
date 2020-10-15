require 'shared_examples/workers'
require 'inhouse_events/workers/sidekiq'

module InhouseEvents
  module Workers
    describe Sidekiq do
      it_behaves_like 'a worker'
    end
  end
end
