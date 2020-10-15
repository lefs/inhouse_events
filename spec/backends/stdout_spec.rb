require 'inhouse_events/backends/stdout'
require 'shared_examples/backends'

module InhouseEvents::Backends
  describe Stdout do
    let(:event_hash) { build(:event_hash) }

    it_behaves_like 'a backend'

    describe '#publish' do
      it 'writes the event as a string to stdout' do
        ::InhouseEvents.configure do |config|
          config.backend_adapter = :stdout
        end
        expect { ::InhouseEvents.queue(event_hash) }.to output.to_stdout
      end
    end
  end
end
