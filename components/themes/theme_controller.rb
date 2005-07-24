class Themes::Plugin < ApplicationController
  uses_component_template_root

  def images
    filename=params[:filename]
    case filename.downcase
    when /.gif$/
      contenttype='image/gif'
    when /(.jpg|.jpeg)$/
      contenttype='image/jpeg'
    when /.png$/
      contenttype='image/png'
    when /.swf$/
      contenttype='application/x-shockwave-flash'
    else
      contenttype='application/binary'
    end
      
    file_object('images',filename,contenttype)
  end

  def javascript
    file_object('javascript',params[:filename],'application/x-javascript')
  end

  def stylesheets
    file_object('stylesheets',params[:filename],'text/css')
  end

  def file_object(type,name,contenttype)
    # We need :steam => false or weird things happen with webrick in 0.13.1
    send_file "components/plugins/themes/#{self.class.themename}/#{type}/#{name}" ,:type => contenttype, :disposition=>'inline', :stream=>false
  end

  def self.theme_layout
    "../../components/plugins/themes/#{themename}/layouts/default"
  end
end

class Themes::ThemeController < ApplicationController
  uses_component_template_root
  cache_sweeper :theme_sweeper
  caches_page :stylesheets, :javascript, :images

  @@theme=config[:theme] #||'azure'

  def self.check_theme
    if config[:theme] and config[:theme] != @@theme
      @@theme=config[:theme]
    end
  end

  def self.active_theme_name
    check_theme
    "plugins/themes/#{@@theme}"
  end

  def self.active_theme
    check_theme
    available_themes.find { |t| t.themename == @@theme }
#    Plugins::Themes::AzureController
  end

  def self.available_themes
    objects=[]
    ObjectSpace.each_object(Class) do |o|
      if Themes::Plugin > o
        objects.push o
      end
    end
    
    objects
  end

  def stylesheets
    render_theme(:action=>'stylesheets', :params => params)
  end

  def javascript
    render_theme(:action=>'javascript', :params => params)
  end

  def images
    render_theme(:action=>'images', :params => params)
  end

end

Dir["#{RAILS_ROOT}/components/plugins/themes/[_a-z]*.rb"].each do |f|
  require_dependency f
end

