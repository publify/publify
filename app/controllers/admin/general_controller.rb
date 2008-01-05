class Admin::GeneralController < Admin::BaseController
  def index
    redirect_to :controller => 'settings'
  end
  
  def update_database
    @current_version = Migrator.current_schema_version
    @needed_version = Migrator.max_schema_version
    @support = Migrator.db_supports_migrations?
    @needed_migrations = Migrator.available_migrations[@current_version..@needed_version].collect do |mig|
      mig.scan(/\d+\_([\w_]+)\.rb$/).flatten.first.humanize
    end
  end

  def migrate
    if request.post?
      Migrator.migrate
      redirect_to :action => 'update_database'
    end
  end
  private
end
