require 'inhouse_events/version'
require 'inhouse_events/configuration'
require 'inhouse_events/engine'
require 'inhouse_events/event'

module InhouseEvents
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = nil
    configure {}
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
    configuration.load_backend
    configuration.load_background_worker
  end

  def self.publish(event)
    configuration.backend.publish(event)
  end

  def self.queue(event)
    configuration.background_worker.handle_event(event)
  end
end

InhouseEvents.reset_configuration
