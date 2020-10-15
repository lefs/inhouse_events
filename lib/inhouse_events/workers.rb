module InhouseEvents
  module Workers
    SUPPORTED = [:inline, :sucker_punch, :sidekiq, :active_job].freeze

    def self.supported?(worker)
      SUPPORTED.include?(worker.to_sym)
    end
  end
end
