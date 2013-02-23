class Migrator
  def current_schema_version
    ActiveRecord::Migrator.current_version
  end

  def migrations_pending?
    pending_migrations.any?
  end

  def pending_migrations
    migrator = ActiveRecord::Migrator.new(:up, migrations_path)
    migrator.pending_migrations
  end

  def migrate
    ActiveRecord::Migrator.migrate(migrations_path)
  end

  private

  def migrations_path
    Rails.root + 'db' + 'migrate'
  end
end
