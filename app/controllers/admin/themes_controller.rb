require 'open-uri'
require 'time'
require 'rexml/document'

class Admin::ThemesController < Admin::BaseController
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
    flash[:notice] = _("Theme changed successfully")
    require "#{this_blog.current_theme.path}/helpers/theme_helper.rb" if File.exists? "#{this_blog.current_theme.path}/helpers/theme_helper.rb"
    redirect_to :action => 'index'
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
  rescue => e
    logger.info(e.message)
    nil

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
