require 'spec_helper'

module InhouseEvents
  describe EventsController, type: :controller do
    routes { InhouseEvents::Engine.routes }

    describe 'POST #create' do
      after { InhouseEvents.reset_configuration }

      it 'constructs a hash with information from the request' do
        # At least one element is needed in hash, because rails 5 does not add
        # it to params if it's empty (event: {}).
        basic_event = { ip_address: kind_of(String) }
        event_param = { event: basic_event }
        additional_request_info = {
          ip_address: kind_of(String),
          user: nil,
          user_agent: kind_of(String),
          session_id: kind_of(String),
          server_timestamp: kind_of(String)
        }
        expected_attrs = basic_event.merge(additional_request_info)

        expect(InhouseEvents).to receive(:queue).with(expected_attrs)

        # Rails 5 old get / post syntax is deprecated.
        if Rails::VERSION::MAJOR >= 5
          post :create, params: event_param
        else
          post :create, event_param
        end
      end
    end
  end
end
