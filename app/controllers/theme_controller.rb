class ThemeController < ApplicationController
  caches_page :stylesheets, :javascript, :images
  session :off
  
  def stylesheets
    render_theme_item(:stylesheets, params[:filename], 'text/css')
  end

  def javascript
    render_theme_item(:javascript, params[:filename], 'text/javascript')
  end

  def images
    render_theme_item(:images, params[:filename])
  end

  def error
    render :nothing => true, :status => 404
  end
  
  def static_view_test
  end

  private
  
  def render_theme_item(type, file, mime = mime_for(file))
    render :text => "Not Found", :status => 404 and return if file.split(%r{[\\/]}).include?("..")
    send_file Theme.current_theme_path + "/#{type}/#{file}", :type => mime, :disposition => 'inline', :stream => false
  end
    
  def mime_for(filename)
    case filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end  
  

end

