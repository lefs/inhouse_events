require 'spec_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

feature 'prevent a pageview event from being sent', js: true do
  before do
    InhouseEvents.configure do |config|
      config.backend_adapter = :test
      config.backend_path = 'support/backends'
      config.background_processing_adapter = :inline
    end
    expect(InhouseEvents.configuration.backend)
      .to be_a_kind_of(InhouseEvents::Backends::Test)
  end

  after(:each) { InhouseEvents.reset_configuration }

  it 'does not send a pageview event when prevented' do
    # A visitor visits a page which should send no pageview event.
    visit ignored_pageview_path
    page.has_css?('title')  # Wait for the page to load.

    # The backend must not have published events about the visit.
    expect(InhouseEvents.configuration.backend.published_events)
      .not_to include('referrer_url')

    # A negative assertion alone is unreliable. Let's back it with a positive
    # assertion.
    # Stub the ignore_events helper to do nothing. The event should then arrive.
    allow(InhouseEventsHelper).to receive(:ignore_events).and_return(nil)

    visit ignored_pageview_path
    page.has_css?('title')  # Wait for the page to load.

    expect(InhouseEvents.configuration.backend.published_events)
      .to include('referrer_url')
  end
end
