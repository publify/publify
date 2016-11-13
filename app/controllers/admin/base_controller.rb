class Admin::BaseController < BaseController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, alert: exception.message
  end

  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  layout 'administration'

  before_action :login_required, except: [:login, :signup]
  before_action :look_for_needed_db_updates, except: [:login, :signup]

  private

  def update_settings_with!(settings_param)
    Blog.transaction do
      settings_param.each { |k, v| this_blog.send("#{k}=", v) }
      if this_blog.save
        flash[:success] = I18n.t('admin.settings.update.success')
      else
        flash[:error] = I18n.t('admin.settings.update.error', messages: this_blog.errors.full_messages.join(', '))
      end
    end
  end

  def destroy_a(klass_to_destroy)
    @record = klass_to_destroy.find(params[:id])
    if @record.respond_to?(:access_by?) && !@record.access_by?(current_user)
      flash[:error] = I18n.t('admin.base.not_allowed')
      return(redirect_to action: 'index')
    end
    @record.destroy
    flash[:notice] = I18n.t('admin.base.successfully_deleted', name: controller_name.humanize)
    redirect_to action: 'index'
  end

  def look_for_needed_db_updates
    migrator = Migrator.new
    redirect_to admin_migrations_path if migrator.migrations_pending?
  end
end
