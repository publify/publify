class Admin::GeneralController < Admin::BaseController
  # Deprecation warning for plugins removal
  before_filter :deprecation_warning

  def index
    if this_blog.base_url.blank?
      this_blog.base_url = blog_base_url
    end
  end

  def redirect
    flash[:notice] = "Please review and save the settings before continuing"
    redirect_to :action => "index"
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

  def update
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog.send("#{k.to_s}=", v) }
        this_blog.save
        flash[:notice] = _('config updated.')
      end
      redirect_to :action => 'index'
    end
  end

  # Deprecation warning for plugins removal
  def deprecation_warning
    if this_blog.deprecation_warning == 1
      Blog.transaction do
        this_blog.deprecation_warning = 0
        this_blog.save
      end
      flash[:notice] = "Deprecation warning: please, notice that most plugins are going to be removed from the main engine in the next version. <a href='http://blog.typosphere.org/articles/2007/04/15/the-futur-of-typo-sidebar-plugins'>Read more on the official Typo blog</a>"
    end
  end

  private
end
