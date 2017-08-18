require 'cancancan'

class BaseController < ApplicationController
  before_action :fire_triggers, :load_lang, :set_paths

  private

  def login_required
    authenticate_user! && authorize!(params[:action], params[:controller])
  end

  def set_paths
    prepend_view_path this_blog.current_theme.view_path
    Dir.glob(File.join(::Rails.root.to_s, 'lib', '*_sidebar/app/views')).select do |file|
      append_view_path file
    end
  end

  def fire_triggers
    Trigger.fire
  end

  def load_lang
    if I18n.available_locales.include?(this_blog.lang.to_sym)
      I18n.locale = this_blog.lang
    elsif I18n.available_locales.include?(this_blog.lang[0..1].to_sym)
      I18n.locale = this_blog.lang[0..1]
    # for the same language used in different areas, e.g. zh_CN, zh_TW
    elsif I18n.available_locales.include?(this_blog.lang.sub('_', '-').to_sym)
      I18n.locale = this_blog.lang.sub('_', '-')
    end
  end

  def add_to_cookies(name, value, path = nil, _expires = nil)
    cookies[name] = { value: value, path: path || "/#{controller_name}", expires: 6.weeks.from_now }
  end

  include BlogHelper
end
