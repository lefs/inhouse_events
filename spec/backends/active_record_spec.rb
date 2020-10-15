require 'spec_helper'
require 'inhouse_events/backends/active_record'
require 'support/backends/active_record_spec_helpers'
require 'shared_examples/backends'

module InhouseEvents::Backends
  describe ActiveRecord, type: :model do
    include ActiveRecordSpecHelpers

    before { setup_events_table }
    after { teardown_events_table }

    it_behaves_like 'a backend'

    describe '#publish' do
      before(:each) do
        ::InhouseEvents.configure do |config|
          config.backend_adapter = :active_record
        end
      end

      after(:each) { ::InhouseEvents.reset_configuration }

      context 'with standard request' do
        it 'inserts a new event into the events table' do
          event_hash = build(:event_hash,
                             client_timestamp: '2015-01-01T10:15:20')
          ::InhouseEvents.queue(event_hash)
          records = ::InhouseEvents::Backends::ActiveRecord::Event.all
          expect(records.size).to eq(1)
          expect(records[0].client_timestamp)
            .to eq(DateTime.new(2015, 1, 1, 10, 15, 20))
        end
      end
    end
  end
end
