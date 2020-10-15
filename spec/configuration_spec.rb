require 'spec_helper'

module InhouseEvents
  describe Configuration do
    after(:each) { InhouseEvents.reset_configuration }

    describe '#backend' do
      context 'when no backend_adapter is specified' do
        it 'defaults to :stdout' do
          InhouseEvents.configure { |config| }
          expect(InhouseEvents.configuration.backend)
            .to be_a_kind_of(InhouseEvents::Backends::Stdout)
        end
      end

      context 'when :active_record backend_adapter is specified' do
        it 'loads the ActiveRecord backend' do
          InhouseEvents.configure do |config|
            config.backend_adapter = :active_record
          end
          expect(InhouseEvents.configuration.backend)
            .to be_a_kind_of(InhouseEvents::Backends::ActiveRecord)
        end
      end
    end

    describe '#background_processing_adapter' do
      it 'should be set to a supported background processing adapter' do
        expect do
          InhouseEvents.configure do |config|
            config.backend_adapter = :stdout
            config.background_processing_adapter = :sucker_punch
          end
        end.not_to raise_error
      end

      it 'raises an error when set to an unsupported adapter' do
        expect do
          InhouseEvents.configure do |config|
            config.backend_adapter = :stdout
            config.background_processing_adapter = :none
          end
        end.to raise_error(RuntimeError)
      end
    end
  end
end
