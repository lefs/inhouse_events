require 'spec_helper'
require 'rspec/rails'

describe InhouseEvents::EventsController, type: :routing do
  routes { InhouseEvents::Engine.routes }

  it 'routes to the inhouse_events events controller' do
    expect(post: '/events')
      .to route_to(controller: 'inhouse_events/events', action: 'create')
  end
end
