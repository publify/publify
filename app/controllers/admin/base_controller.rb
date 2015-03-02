class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  layout 'administration'

  before_action :login_required, except: [:login, :signup]
  before_action :look_for_needed_db_updates, except: [:login, :signup, :update_database, :migrate]
  before_action :check_and_generate_secret_token, except: [:login, :signup, :update_database, :migrate]

  private

  def parse_date_time(str)
    return unless str
    DateTime.strptime(str, '%B %e, %Y %I:%M %p GMT%z').utc
  rescue ArgumentError
    Time.parse(str).utc
  end

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
    return render('admin/shared/destroy') unless request.post?
    @record.destroy
    flash[:notice] = I18n.t('admin.base.successfully_deleted', name: controller_name.humanize)
    redirect_to action: 'index'
  end

  def look_for_needed_db_updates
    migrator = Migrator.new
    if migrator.migrations_pending?
      redirect_to controller: '/admin/settings', action: 'update_database'
    end
  end

  def check_and_generate_secret_token
    return if defined? $TESTING

    checker = Admin::TokenChecker.new
    return if checker.safe_token_in_use?

    begin
      checker.generate_token
      flash[:notice] = I18n.t('admin.base.restart_application')
    rescue
      flash[:error] = I18n.t('admin.base.cant_generate_secret', checker_file: checker.file)
    end
  end
end
