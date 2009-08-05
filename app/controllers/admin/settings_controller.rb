class Admin::SettingsController < Admin::BaseController

  cache_sweeper :blog_sweeper

  def index
    if this_blog.base_url.blank?
      this_blog.base_url = blog_base_url
    end
    load_settings
  end
  
  def read; load_settings end
  def write; load_settings end
  def feedback; load_settings end
  
  def seo
    load_settings
    if File.exists? "#{RAILS_ROOT}/public/robots.txt"
      @setting.robots = ""
      file = File.readlines("#{RAILS_ROOT}/public/robots.txt")
      file.each do |line|
        @setting.robots << line
      end
    end
  end
  
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
      
      save_robots unless params[:setting][:robots].blank?
      
      redirect_to :action => params[:from]
    end
  rescue ActiveRecord::RecordInvalid
    render :action => params[:from]
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
  def load_settings
    @setting = this_blog
  end
  
  def save_robots
    if File.writable? "#{RAILS_ROOT}/public/robots.txt"
      robots = File.new("#{RAILS_ROOT}/public/robots.txt", "r+")
      robots.write(params[:setting][:robots])
      robots.close
    end
  end
end
