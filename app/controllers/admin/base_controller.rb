class Admin::BaseController < ApplicationController
  layout 'administration'
  before_filter :login_required, :except => [ :login, :signup ]
  before_filter :look_for_needed_db_updates, :except => [:update_database, :migrate]
  private
  
  def look_for_needed_db_updates
    redirect_to :controller => '/admin/general', :action => 'update_database' if current_schema_version != max_schema_version
  end
  
  def migrations_path
    "#{RAILS_ROOT}/db/migrate"
  end

  def available_migrations
    @available_migrations ||= Dir["#{migrations_path}/[0-9]*_*.rb"].sort
  end

  def current_schema_version
    ActiveRecord::Migrator.current_version
  end

  def max_schema_version
     available_migrations.size
  end
  
end
