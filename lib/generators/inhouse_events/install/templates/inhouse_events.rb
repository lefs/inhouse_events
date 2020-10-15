InhouseEvents.configure do |config|
  config.backend_adapter = :active_record
  config.background_processing_adapter = :active_job
end
