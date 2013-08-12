class Admin::BaseController < ApplicationController
  cattr_accessor :look_for_migrations
  @@look_for_migrations = true
  layout 'administration'
  before_filter :login_required, :except => [ :login, :signup ]
  before_filter :look_for_needed_db_updates, :except => [:login, :signup, :update_database, :migrate]
  before_filter :check_and_generate_secret_token, :except => [:login, :signup, :update_database, :migrate]

  def insert_editor
    editor = 'visual'
    editor = 'simple' if params[:editor].to_s == 'simple'
    current_user.editor = editor
    current_user.save!

    render :partial => "#{editor}_editor"
  end

  private

  def save_a(object, title)
    if object.save
      flash[:notice] = _("#{title.capitalize} was successfully saved.")
    else
      flash[:error] = _("#{title.capitalize} could not be saved.")
    end
    redirect_to action: 'index'
  end

  def destroy_a(klass_to_destroy)
    @record = klass_to_destroy.find(params[:id])
    if @record.respond_to?(:access_by?) && !@record.access_by?(current_user)
      flash[:error] = _("Error, you are not allowed to perform this action")
      return(redirect_to action: 'index')
    end
    return render('admin/shared/destroy') unless request.post?
    @record.destroy
    flash[:notice] = _("This #{controller_name.humanize} was deleted successfully")
    redirect_to action: 'index'
  end

  def look_for_needed_db_updates
    migrator = Migrator.new
    if migrator.migrations_pending?
      redirect_to :controller => '/admin/settings', :action => 'update_database'
    end
  end

  def check_and_generate_secret_token
    return if defined? $TESTING

    checker = Admin::TokenChecker.new
    return if checker.safe_token_in_use?

    begin
      checker.generate_token
      flash[:error] = _("For security reasons, you should restart your Publify application. Enjoy your blogging experience.")
    rescue
      flash[:error] = _("Error: can't generate secret token. Security is at risk. Please, change %s content", checker.file)
    end
  end
end
