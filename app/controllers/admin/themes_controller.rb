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
    FileUtils.rm_rf(%w{stylesheets javascript images}.collect{|v| page_cache_directory + "/#{v}/theme"})
    this_blog.current_theme(:reload)
    flash[:success] = I18n.t('admin.themes.switchto.success')
    redirect_to :action => 'index'
  end

  protected
end
