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
        :nonbreaking_force_tab => true,
        :extended_valid_elements => %w{typo:code[lang]img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name|obj|param|embed]},      
        :theme_advanced_resize_horizontal => false,
        :paste_auto_cleanup_on_paste => true,
        :theme_advanced_buttons1 => %w{formatselect bold italic underline strikethrough
                                       separator justifyleft justifycenter justifyright
                                       separator bullist numlist forecolor backcolor
                                       separator link unlink image media separator emotions nonbreaking },
        :theme_advanced_buttons2 => [],
        :theme_advanced_buttons3 => [],
        :plugins => %w{contextmenu paste media advimage safari emotions advlink autosave nonbreaking }},
      :only => [:new, :edit])
  end

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
