require 'open-uri'
require 'time'
require 'rexml/document'

class Admin::ThemesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    @themes = Theme.find_all
    @themes.each do |theme|
      # TODO: Move to Theme
      theme.description_html = TextFilter.filter_text(theme.description, [:markdown, :smartypants])
    end
    @active = this_blog.current_theme
  end

  def preview
    theme = Theme.find(params[:theme])
    send_file File.join(theme.path, 'preview.png'),
              type: 'image/png', disposition: 'inline', stream: false
  end

  def switchto
    this_blog.theme = params[:theme]
    this_blog.save
    zap_theme_caches
    this_blog.current_theme(:reload)
    flash[:success] = I18n.t('admin.themes.switchto.success')
    require "#{this_blog.current_theme.path}/helpers/theme_helper.rb" if File.exist? "#{this_blog.current_theme.path}/helpers/theme_helper.rb"
    redirect_to admin_themes_url
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w(stylesheets javascript images).map { |v| page_cache_directory + "/#{v}/theme" })
  end
end
