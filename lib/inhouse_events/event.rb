require 'securerandom'
require 'json'

module InhouseEvents
  class Event
    EVENT_TYPES = {
      pageview: 'pageview',
      click: 'click',
      form_submission: 'form_submission'
    }.freeze

    attr_reader :payload, :type

    def initialize(payload = {})
      @payload = payload
      @payload[:server_event_id] = SecureRandom.uuid
      @type = EVENT_TYPES[:pageview]
    end

    def merge(h)
      @payload = @payload.merge(h)
    end

    def to_json
      JSON.dump(@payload)
    end

    def to_hash
      @payload
    end

    def self.valid_event_type?(t)
      EVENT_TYPES.values.include?(t)
    end
  end
end
