class Admin::MigrationsController < Admin::BaseController
  cache_sweeper :blog_sweeper
  skip_before_action :look_for_needed_db_updates

  def show
    @current_version = migrator.current_schema_version
    @needed_migrations = migrator.pending_migrations
  end

  def update
    migrator.migrate
    redirect_to admin_migrations_url
  end

  private

  def migrator
    @migrator ||= Migrator.new
  end
end
