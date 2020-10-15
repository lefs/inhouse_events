require 'active_support/inflector'
require 'inhouse_events/workers'

module InhouseEvents
  class Configuration
    attr_reader :backend
    attr_accessor :backend_adapter
    attr_accessor :backend_path
    attr_accessor :backend_credentials
    attr_reader :background_processing_adapter
    attr_reader :background_worker

    def initialize
      self.backend_adapter = :stdout
      @backend_path = 'inhouse_events/backends'
      @background_processing_adapter = :inline
    end

    def background_processing_adapter=(adapter)
      unless InhouseEvents::Workers.supported?(adapter)
        raise "'#{adapter}' is not a supported background processing adapter!"
      end

      @background_processing_adapter = adapter
    end

    def load_backend
      require File.join(@backend_path, @backend_adapter.to_s)
      backend_class = InhouseEvents::Backends
                      .const_get(@backend_adapter.to_s.camelize)
      @backend = backend_class.new
      @backend.verify_credentials
    end

    def load_background_worker
      require File.join('inhouse_events/workers',
                        @background_processing_adapter.to_s)
      worker_cls_name = @background_processing_adapter.to_s.camelize
      worker_fqn = "InhouseEvents::Workers::#{worker_cls_name}"
      @background_worker = worker_fqn.safe_constantize
    end
  end
end
