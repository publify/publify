class Admin::ThemesController < Admin::BaseController
  
  def index
    @themes = ThemeSystem.themes
    @active = ThemeSystem.theme
  end
  
  def preview
    send_file RAILS_ROOT + "#{ThemeSystem.themes_root}/#{params[:theme]}/preview.png", :type => 'image/png', :disposition => 'inline', :stream => false
  end
  
  def switchto
    
    setting = (Setting.find_by_name('theme') or Setting.new("name" => 'theme'))

    setting.value = params[:theme]
    setting.save
    
    redirect_to :action => 'index'
    
  end
  
end
