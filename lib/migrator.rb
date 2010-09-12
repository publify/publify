module Migrator
  mattr_accessor :offer_migration_when_available
  @@offer_migration_when_available = true

  def self.migrations_path
    "#{::Rails.root.to_s}/db/migrate"
  end

  def self.available_migrations
    Dir["#{migrations_path}/[0-9]*_*.rb"].sort_by { |name| name.scan(/\d+/).first.to_i }
  end

  def self.current_schema_version
    ActiveRecord::Migrator.current_version rescue 0
  end

  def self.max_schema_version
    available_migrations.size
  end

  def self.db_supports_migrations?
    ActiveRecord::Base.connection.supports_migrations?
  end

  def self.migrate(version = nil)
    ActiveRecord::Migrator.migrate("#{migrations_path}/", version)
  end
end
