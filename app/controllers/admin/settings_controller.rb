class Admin::SettingsController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    if this_blog.base_url.blank?
      this_blog.base_url = blog_base_url
    end
    load_settings
  end

  def write; load_settings end
  def feedback; load_settings end
  def errors; load_settings; end
  
  def redirect
    flash[:notice] = _("Please review and save the settings before continuing")
    redirect_to :action => "index"
  end

  def update
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog.send("#{k.to_s}=", v) }
        this_blog.save
        flash[:notice] = _('config updated.')
      end

      redirect_to :action => params[:from]
    end
  rescue ActiveRecord::RecordInvalid
    render params[:from]
  end

  def update_database
    @current_version = Migrator.current_schema_version

    path = File.expand_path("db/migrate")
    migrator = ActiveRecord::Migrator.new(:up, path)
    if migrator.pending_migrations.size > 0
      @pending = migrator.pending_migrations.count
      @needed_migrations = migrator.pending_migrations
    else
      @needed_version = @current_version 
      @needed_migrations = nil
    end	
  end

  def migrate
    if request.post?
      Migrator.migrate
      redirect_to :action => 'update_database'
    end
  end

  private
  def load_settings
    @setting = this_blog
  end
end
