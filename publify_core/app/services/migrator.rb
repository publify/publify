class Migrator
  def current_schema_version
    ActiveRecord::Migrator.current_version
  end

  def migrations_pending?
    pending_migrations.any?
  end

  def pending_migrations
    all_migrations = ActiveRecord::Migrator.migrations(migrations_paths)
    migrator = ActiveRecord::Migrator.new(:up, all_migrations)
    migrator.pending_migrations
  end

  def migrate
    ActiveRecord::Migrator.migrate(migrations_paths)
  end

  private

  def migrations_paths
    ActiveRecord::Migrator.migrations_paths
  end
end
