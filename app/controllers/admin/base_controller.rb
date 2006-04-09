class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true

  layout 'administration'
  before_filter :login_required, :except => [ :login, :signup ]
  before_filter :look_for_needed_db_updates, :except => [:login, :signup, :update_database, :migrate]

  cache_sweeper :blog_sweeper

  private

  def look_for_needed_db_updates
    if Migrator.offer_migration_when_available
      redirect_to :controller => '/admin/general', :action => 'update_database' if Migrator.current_schema_version != Migrator.max_schema_version
    end
  end

  include_protected ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper

end
