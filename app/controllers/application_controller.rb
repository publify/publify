# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ::LoginSystem
  protect_from_forgery only: [:edit, :update, :delete]

  before_action :reset_local_cache, :fire_triggers, :load_lang, :set_paths
  after_action :reset_local_cache

  class << self
    unless self.respond_to? :template_root
      def template_root
        ActionController::Base.view_paths.last
      end
    end
  end

  protected

  def set_paths
    prepend_view_path "#{::Rails.root}/themes/#{this_blog.theme}/views"
    Dir.glob(File.join(::Rails.root.to_s, 'lib', '*_sidebar/app/views')).select do |file|
      append_view_path file
    end
  end

  def setup_themer
    # Ick!
    self.class.view_paths = ::ActionController::Base.view_paths.dup.unshift("#{::Rails.root}/themes/#{this_blog.theme}/views")
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

  def reset_local_cache
    session session: new unless session
    @current_user = nil
  end

  # The base URL for this request, calculated by looking up the URL for the main
  # blog index page.
  def blog_base_url
    url_for(controller: '/articles').gsub(%r{/$}, '')
  end

  def add_to_cookies(name, value, path = nil, _expires = nil)
    cookies[name] = { value: value, path: path || "/#{controller_name}", expires: 6.weeks.from_now }
  end

  def this_blog
    @blog ||= Blog.default
  end
end
