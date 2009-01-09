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
      url = "http://typogarden.org/themes.xml"
      open(url) do |http|
        @themes = parse_catalogue(http.read)
      end
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
  end

  private
  
  class ThemeItem < Struct.new(:image, :name, :url)
    def to_s; name; end
  end
  
  def parse_catalogue(body)
    xml = REXML::Document.new(body)
 
    items = []
 
    REXML::XPath.each(xml, "/themes/theme/") do |elem|
      item = ThemeItem.new
      item.image    = REXML::XPath.match(elem, "image/text()").first.value rescue ""
      item.url      = REXML::XPath.match(elem, "url/text()").first.value rescue ""
      item.name     = REXML::XPath.match(elem, "name/text()").first.value rescue ""
      items << item
    end
    items
    items.sort_by { |item| item.name }
  end
  
end
