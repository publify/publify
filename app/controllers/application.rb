# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem

  before_filter :get_the_blog_object
  before_filter :fire_triggers
  after_filter :flush_the_blog_object

  around_filter Blog

  protected

  def fire_triggers
    Trigger.fire
  end

  def with_blog_scoped_classes(klasses=[Content, Article, Comment, Page, Trackback], &block)
    default_id = this_blog.id
    scope_hash = { :find => { :conditions => "blog_id = #{default_id}"},
                   :create => { :blog_id => default_id } }
    klasses.inject(block) do |blk, klass|
      lambda { klass.with_scope(scope_hash, &blk) }
    end.call
  end

  def article_url(article, only_path = true, anchor = nil)
    article.location(anchor, only_path)
  end

  def server_url
    this_blog.server_url
  end

  def cache
    $cache ||= SimpleCache.new 1.hour
  end

  def get_the_blog_object
    @blog = Blog.default || Blog.create!
    true
  end

  def flush_the_blog_object
    @blog = nil
    true
  end

  def this_blog
    @blog || Blog.default || Blog.new
  end
  helper_method :this_blog

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

