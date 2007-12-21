class Admin::ThemesController < Admin::BaseController

  def index
    @themes = Theme.find_all
    @themes.each do |theme|
      theme.description_html = TextFilter.filter_text(this_blog, theme.description, nil, [:markdown,:smartypants])
    end
    @active = this_blog.current_theme
  end

  def preview
    send_file "#{Theme.themes_root}/#{params[:theme]}/preview.png", :type => 'image/png', :disposition => 'inline', :stream => false
  end

  def switchto
    this_blog.theme = params[:theme]
    this_blog.save
    redirect_to :action => 'index'
  end

  def editor
    case params[:type].to_s
    when "stylesheet"
      path = this_blog.current_theme.path + "/stylesheets/"
      if params[:file] =~ /css$/
        filename = params[:file]
      else
        flash[:error] = "You are not authorized to open this file"
        return
      end
    when "layout"
      path = this_blog.current_theme.path + "/layouts/"
      if params[:file] =~ /rhtml$|erb$/
        filename = params[:file]
      else
        flash[:error] = "You are not authorized to open this file"
        return
      end
    end

    if path and filename
      if File.exists? path + filename
        if File.writable? path + filename
          case request.method
          when :post
            theme = File.new(path + filename, "r+")
            theme.write(params[:theme_body])
            theme.close
            flash[:notice] = "File saved successfully"
            zap_theme_caches
          end
        else
          flash[:notice] = "Unable to write file"
        end
        @file = ""
        file = File.readlines(path + filename, "r")
        file.each do |line|
          @file << line
        end
      end
    end
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
  end
end
