require 'spec_helper'

module InhouseEvents
  describe Event do
    let(:event) { build(:event) }

    describe '#initialize' do
      it 'accepts an hash to be used as event attributes' do
        event = InhouseEvents::Event.new(attr1: 'val1', attr2: 'val2')

        expect(event.to_json).to match(/attr1/)
        expect(event.to_json).to match(/val1/)
        expect(event.to_json).to match(/attr2/)
        expect(event.to_json).to match(/val2/)
      end
    end

    describe '#type' do
      it "returns the event's type" do
        expect(Event.valid_event_type?(event.type)).to be true
      end
    end

    describe '#merge' do
      it 'takes a hash of additional attributes for the event' do
        event.merge(new_attr: 'val')
        expect(event.to_json).to match(/new_attr/)
        expect(event.to_json).to match(/val/)
      end
    end

    describe '#to_json' do
      it 'outputs a JSON representation of the event' do
        output = event.to_json
        expect { JSON.parse(output) }.not_to raise_error
      end

      it 'the JSON output contains the server_event_id' do
        output = JSON.parse(event.to_json)
        expect(output).to have_key('server_event_id')
      end
    end
  end
end
