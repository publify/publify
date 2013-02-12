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
  def look_for_needed_db_updates
    if Migrator.offer_migration_when_available
      redirect_to :controller => '/admin/settings', :action => 'update_database' if Migrator.current_schema_version != Migrator.max_schema_version
    end
  end
  
  def check_and_generate_secret_token
    return unless TypoBlog::Application.config.secret_token == "08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a"
    
    flash[:error] = _("For security reasons, you should restart your Typo application. Enjoy your blogging experience.")
        
    file = File.join(Rails.root, "config", "secret.token")

    return unless File.open(file, "r") { |f| f.read.delete("\n") } == "08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a"
    
    if ! File.writable?(file)
      flash[:error] = _("Error: can't generate secret token. Security is at risk. Please, change %s content", file)
      return
    end
    
    newtoken = Digest::SHA1.hexdigest("#{Blog.default.base_url} #{DateTime.now.to_s}")
        
    File.open(file, 'w') {|f| f.write(newtoken) }

  end
  
  
end
