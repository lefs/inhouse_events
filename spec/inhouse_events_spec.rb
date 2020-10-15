require 'spec_helper'

describe InhouseEvents do
  after(:each) { InhouseEvents.reset_configuration }

  let(:event_hash) { build(:event_hash) }
  let(:event) { build(:event) }

  describe '.publish' do
    it 'publishes an event to the backend' do
      expect(InhouseEvents.configuration.backend).to receive(:publish)
      InhouseEvents.publish(event)
    end
  end

  describe '.queue' do
    it 'hands off an event to a background worker' do
      expect(InhouseEvents.configuration.background_worker)
        .to be_truthy
      expect(InhouseEvents.configuration.background_worker)
        .to receive(:handle_event).with(event_hash)

      InhouseEvents.queue(event_hash)
    end
  end

  describe '.configure' do
    it 'sets the name of the backend_adapter' do
      InhouseEvents.configure do |config|
        config.backend_adapter = :active_record
      end

      expect(InhouseEvents.configuration.backend_adapter).to eq(:active_record)
    end

    it 'optionally sets the path from where the backend can be loaded' do
      backend_path = 'support/backends'
      InhouseEvents.configure do |config|
        config.backend_adapter = :test
        config.backend_path = backend_path
      end

      expect(InhouseEvents.configuration.backend_path).to eq(backend_path)
    end
  end
end
