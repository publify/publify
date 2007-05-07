class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  if Blog.default && Blog.default.editor == 2
    uses_tiny_mce(
      :options => {
        :theme => 'advanced',
        :theme_advanced_toolbar_location => "top",
        :theme_advanced_toolbar_align => "left",
        :theme_advanced_resizing => true,
        :theme_advanced_resize_horizontal => false,
        :paste_auto_cleanup_on_paste => true,
        :theme_advanced_buttons1 => %w{formatselect bold italic underline strikethrough
                                       separator justifyleft justifycenter justifyright
                                       separator bullist numlist forecolor backcolor
                                       separator link unlink image},
        :theme_advanced_buttons2 => [],
        :theme_advanced_buttons3 => [],
        :plugins => %w{contextmenu paste}},
      :only => [:new, :edit])
  end

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
