require 'spec_helper'
require 'capybara/poltergeist'
require 'sucker_punch/testing/inline'
require 'support/backends/test'
require 'support/backends/active_record_spec_helpers'
begin
  require 'active_job'
rescue LoadError => e
  raise unless e.message == 'cannot load such file -- active_job'
end

Capybara.javascript_driver = :poltergeist

feature 'create a pageview event on a page load', js: true do
  after(:each) { InhouseEvents.reset_configuration }

  shared_examples_for 'a pageview event was sent' do
    it 'sends an AJAX post with data related to the pageview' do
      # A visitor visits a page on the web site.
      visit root_path
      page.has_css?('title') # Wait for the page to load.

      # The backend must have created an event about the visit.
      expect(InhouseEvents.configuration.backend.published_events)
        .to include('referrer_url')
    end
  end

  context 'background_processing_adapter == :sucker_punch' do
    before do
      InhouseEvents.configure do |config|
        config.backend_adapter = :test
        config.backend_path = 'support/backends'
        config.background_processing_adapter = :sucker_punch
      end
      expect(InhouseEvents.configuration.backend)
        .to be_a_kind_of(InhouseEvents::Backends::Test)
    end

    it_behaves_like 'a pageview event was sent'
  end

  context 'background_processing_adapter == :inline' do
    before do
      InhouseEvents.configure do |config|
        config.backend_adapter = :test
        config.backend_path = 'support/backends'
        config.background_processing_adapter = :inline
      end
      expect(InhouseEvents.configuration.backend)
        .to be_a_kind_of(InhouseEvents::Backends::Test)
    end

    it_behaves_like 'a pageview event was sent'
  end

  context 'background_processing_adapter == :active_job',
    if: defined?(::ActiveJob) do

    before(:all) { ActiveJob::Base.logger.level = 3 }

    context 'backend_adapter == :test' do
      before do
        InhouseEvents.configure do |config|
          config.backend_adapter = :test
          config.backend_path = 'support/backends'
          config.background_processing_adapter = :active_job
        end
        expect(InhouseEvents.configuration.backend)
          .to be_a_kind_of(InhouseEvents::Backends::Test)
      end

      it_behaves_like 'a pageview event was sent'
    end

    context 'backend_adapter == :active_record' do
      include ActiveRecordSpecHelpers

      before do
        InhouseEvents.configure do |config|
          config.backend_adapter = :active_record
          config.background_processing_adapter = :active_job
        end

        setup_events_table
      end

      after { teardown_events_table }

      it 'sends an AJAX post with data related to the pageview' do
        # A visitor visits a page on the web site.
        visit root_path
        page.has_css?('title') # Wait for the page to load.

        events = ::InhouseEvents::Backends::ActiveRecord::Event.all
        expect(events.size).to eq(1)
        expect(events[0].referrer_url).to eq('')
      end
    end
  end
end
