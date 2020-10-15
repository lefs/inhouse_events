require 'spec_helper'
require 'support/backends/active_record_spec_helpers'

module InhouseEvents::Backends
  class ActiveRecord
    describe VisitId do
      include ActiveRecordSpecHelpers

      before { setup_events_table }
      after { teardown_events_table }

      before(:each) do
        ::InhouseEvents.configure do |config|
          config.backend_adapter = :active_record
        end
      end

      after(:each) { ::InhouseEvents.reset_configuration }

      def publish_event(time, session_id = nil)
        allow(Time).to receive(:now).and_return(time) unless time.nil?
        event_hash = {}
        event_hash[:server_timestamp] = time.iso8601 unless time.nil?
        event_hash[:session_id] = session_id unless session_id.nil?
        event = build(:event_hash, event_hash)
        ::InhouseEvents.queue(event)
      end

      def all_events
        ::InhouseEvents::Backends::ActiveRecord::Event.all
      end

      it 'creates visit_id for new event' do
        publish_event(Time.utc(2015, 1, 1, 10, 15, 20), '123')
        expect(all_events[0].visit_id).to be_truthy
      end

      context 'creates different visit_id for events' do
        it 'without specified session_id' do
          publish_event(Time.utc(2015, 1, 1, 10, 15, 20))
          publish_event(Time.utc(2015, 1, 1, 10, 15, 20))
          expect(all_events.first.visit_id).not_to eq(all_events.second.visit_id)
        end

        it 'without specified server_timestamp' do
          publish_event(nil, '123')
          publish_event(nil, '123')
          expect(all_events.first.visit_id).not_to eq(all_events.second.visit_id)
        end

        it 'without specified session id and server_timestamp' do
          publish_event(nil)
          publish_event(nil)
          expect(all_events.first.visit_id).not_to eq(all_events.second.visit_id)
        end

        it 'that are more than 30 minutes apart' do
          publish_event(Time.utc(2015, 1, 1, 10, 15, 20), '123')
          publish_event(Time.utc(2015, 1, 1, 10, 45, 21), '123')
          expect(all_events.first.visit_id).not_to eq(all_events.second.visit_id)
        end
      end

      context 'creates the same visit_id for events' do
        it 'that have the same session_id and are less than 30min apart' do
          publish_event(Time.utc(2015, 1, 1, 10, 15, 20), '123')
          publish_event(Time.utc(2015, 1, 1, 10, 45, 19), '123')
          expect(all_events.first.visit_id).to eq(all_events.second.visit_id)
        end

        it 'using latest event according to server_timestamp' do
          publish_event(Time.utc(2015, 1, 1, 10, 35, 19), '123')
          publish_event(Time.utc(2015, 1, 1, 10, 4, 20), '123')
          publish_event(Time.utc(2015, 1, 1, 10, 40, 20), '123')
          expect(all_events.first.visit_id).to eq(all_events.third.visit_id)
        end
      end
    end
  end
end
