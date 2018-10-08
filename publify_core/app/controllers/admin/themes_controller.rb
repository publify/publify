# frozen_string_literal: true

require 'open-uri'
require 'time'
require 'rexml/document'

class Admin::ThemesController < Admin::BaseController
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
    this_blog.current_theme(:reload)
    flash[:success] = I18n.t('admin.themes.switchto.success')
    redirect_to admin_themes_url
  end
end
