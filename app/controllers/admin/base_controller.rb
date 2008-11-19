module Admin
end
class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  layout 'administration'
  before_filter :login_required, :except => [ :login, :signup ]
  before_filter :look_for_needed_db_updates, :except => [:login, :signup, :update_database, :migrate]

  private
  def look_for_needed_db_updates
    if Migrator.offer_migration_when_available
      redirect_to :controller => '/admin/settings', :action => 'update_database' if Migrator.current_schema_version != Migrator.max_schema_version
    end
  end

  def sweep_cache
    if Blog.default
      if Blog.default.cache_option == "caches_action_with_params"
        sweep_cache_action
      end
      if Blog.default.cache_option == "caches_page"
        sweep_cache_html
      end
    end
  end

  def sweep_cache_action
    PageCache.sweep_all
    expire_fragment(/.*/)
  end

  def sweep_cache_html
    PageCache.sweep_all
    expire_fragment(/^contents_html.*/)
  end
end
