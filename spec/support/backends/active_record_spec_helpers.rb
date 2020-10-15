require 'inhouse_events/backends/active_record'
require 'generators/inhouse_events/install/install_generator'

module ActiveRecordSpecHelpers
  TMP_ROOT = File.expand_path('../../tmp', __FILE__)
  MIGRATIONS_DIR = File.join(TMP_ROOT, 'db/migrate')

  def activerecord_below_5_2?
    ::ActiveRecord.version.release < Gem::Version.new('5.2.0')
  end

  def setup_events_table
    FileUtils.rm_rf(TMP_ROOT)
    ::InhouseEvents::Generators::InstallGenerator.new(
      {},
      ['--quiet'],
      destination_root: TMP_ROOT
    ).invoke('create_events_table_migration')
    ::ActiveRecord::Migration.verbose = false
    if activerecord_below_5_2?
      ::ActiveRecord::Migrator.migrate(MIGRATIONS_DIR)
    else
      ::ActiveRecord::MigrationContext.new(MIGRATIONS_DIR).migrate
    end
    # SQLite seems to cache the absence of the events table per thread. It then
    # reports that the table does not exist long after the above migrations have
    # created the table. Avoid this by reconnecting.
    ::ActiveRecord::Base.connection.disconnect!
    ::ActiveRecord::Base.establish_connection
  end

  def teardown_events_table
    ::ActiveRecord::Migration.verbose = false
    if activerecord_below_5_2?
      ::ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, 0)
    else
      ::ActiveRecord::MigrationContext.new(MIGRATIONS_DIR).migrate(0)
    end
  end
end
