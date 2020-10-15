begin
  require 'inhouse_events/workers/active_job'
rescue LoadError => e
  raise unless e.message == 'cannot load such file -- active_job'

  # This is needed for the if: clause below.
  module InhouseEvents::Workers
    module ActiveJob; end
  end
end
require 'shared_examples/workers'

module InhouseEvents
  module Workers
    describe ActiveJob, if: defined?(::ActiveJob) do
      it_behaves_like 'a worker'
    end
  end
end
