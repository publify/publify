class Admin::ThemesController < Admin::BaseController
  
  def index
    @themes = Theme.find_all
    @themes.each do |theme|
      theme.description_html = filter_text(theme.description,[:markdown,:smartypants])
    end
    @active = Theme.current
  end
  
  def preview
    send_file "#{Theme.themes_root}/#{params[:theme]}/preview.png", :type => 'image/png', :disposition => 'inline', :stream => false
  end
  
  def switchto
    
    setting = (Setting.find_by_name('theme') or Setting.new("name" => 'theme'))

    setting.value = params[:theme]
    setting.save
    
    redirect_to :action => 'index'
    
  end
  
end
