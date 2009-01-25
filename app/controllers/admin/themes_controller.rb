class Admin::ThemesController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  cache_sweeper :blog_sweeper

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
    zap_theme_caches
    this_blog.current_theme(:reload)
    redirect_to :action => 'index'
  end

  def editor
    case params[:type].to_s
    when "stylesheet"
      path = this_blog.current_theme.path + "/stylesheets/"
      if params[:file] =~ /css$/
        filename = params[:file]
      else
        flash[:error] = _("You are not authorized to open this file")
        return
      end
    when "layout"
      path = this_blog.current_theme.path + "/layouts/"
      if params[:file] =~ /rhtml$|erb$/
        filename = params[:file]
      else
        flash[:error] = _("You are not authorized to open this file")
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
            flash[:notice] = _("File saved successfully")
            zap_theme_caches
          end
        else
          flash[:notice] = _("Unable to write file")
        end
        @file = ""
        file = File.readlines(path + filename, "r")
        file.each do |line|
          @file << line
        end
      end
    end
  end

  def catalogue
    # Data get by this URI is a JSON formatted
    # The return is a list. All element represent a item
    # Each item is a hash with this key :
    #  * uid
    #  * download_uri
    #  * name
    #  * author
    #  * description
    #  * tags
    #  * screenshot_uri
    url = "http://www.dev411.com/typo/themes_2-1.txt"
    open(url) do |http|
      @themes = parse_catalogue_by_json(http.read)
    end
  rescue OpenURI::HTTPError
    @themes = []
    @error = true
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
  end

  private
  
  class ThemeItem < Struct.new(:image, :name, :url, :author, :description)
    def to_s; name; end
  end

  def parse_catalogue_by_json(body)
    items_json = JSON.parse(body)
    items = []
    items_json.each do |elem|
      next unless elem['download_uri'] # No display theme without download URI
      item = ThemeItem.new
      item.image = elem['screenshot_uri']
      item.url = elem['download_uri']
      item.name = elem['name']
      item.author = elem['author']
      item.description = elem['description']
      items << item
    end
    items
    items.sort_by { |item| item.name }
  end
end
