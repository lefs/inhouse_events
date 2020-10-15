require 'spec_helper'

describe InhouseEventsHelper do
  describe '.ignore_events' do
    it 'outputs javascript to skip pageview events' do
      expect(InhouseEventsHelper.ignore_events).to match('<script>')
    end

    it 'outputs HTML safe code' do
      expect(InhouseEventsHelper.ignore_events).to be_html_safe
    end

    it 'lists the event types to ignore' do
      expect(InhouseEventsHelper.ignore_events(:pageview)).to match('["pageview"]')
    end
  end
end
