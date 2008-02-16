class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  layout 'administration'
  before_filter :login_required, :except => [ :login, :signup ]
  before_filter :look_for_needed_db_updates, :except => [:login, :signup, :update_database, :migrate]
  before_filter :deprecation_warning
  cache_sweeper :blog_sweeper

  private

  # Deprecation warning for plugins removal
  def deprecation_warning
    if this_blog.deprecation_warning != 42
      Blog.transaction do
        this_blog.deprecation_warning = 42
        this_blog.save
      end
      flash[:error] = "Deprecation warning: please, notice that most plugins have been  removed from the main engine in this new version. To download them, run <code>script/plugins install myplugin</code>, where myplugin is one of them at http://svn.typosphere.org/typo/plugins/"
    end
  end
  
  def look_for_needed_db_updates
    if Migrator.offer_migration_when_available
      redirect_to :controller => '/admin/general', :action => 'update_database' if Migrator.current_schema_version != Migrator.max_schema_version
    end
  end
end
