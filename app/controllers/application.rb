# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
  before_filter :reset_local_cache, :fire_triggers
  after_filter :reset_local_cache

  protected

  def fire_triggers
    Trigger.fire
  end

  def reset_local_cache
    CachedModel.cache_reset
    session[:user].reload if session[:user]
  end

  # Axe?
  def server_url
    this_blog.base_url
  end

  def cache
    $cache ||= SimpleCache.new 1.hour
  end

  @@blog_id_for = Hash.new

  # The Blog object for the blog that matches the current request.  This is looked
  # up using Blog.find_blog and cached for the lifetime of the controller instance;
  # generally one request.
  def this_blog
    @blog ||= if @@blog_id_for[blog_base_url]
                Blog.find(@@blog_id_for[blog_base_url])
              else
                returning(Blog.find_blog(blog_base_url)) do |blog|
                  @@blog_id_for[blog_base_url] = blog.id
                end
              end
  end
  helper_method :this_blog

  # The base URL for this request, calculated by looking up the URL for the main
  # blog index page.  This is matched with Blog#base_url to determine which Blog
  # is supposed to handle this URL
  def blog_base_url
    url_for(:controller => '/articles').gsub(%r{/$},'')
  end

  def self.include_protected(*modules)
    modules.reverse.each do |mod|
      included_methods = mod.public_instance_methods.reject do |meth|
        self.method_defined?(meth)
      end
      self.send(:include, mod)
      included_methods.each do |meth|
        protected meth
      end
    end
  end
end

