# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem

  before_filter :get_the_blog_object
  after_filter :flush_the_blog_object

  protected

  def with_blog_scoped_classes(klasses=[Content, Article, Comment, Page, Trackback], &block)
    default_id = this_blog.id
    scope_hash = { :find => { :conditions => "blog_id = #{default_id}"},
                   :create => { :blog_id => default_id } }
    klasses.inject(block) do |blk, klass|
      lambda { klass.with_scope(scope_hash, &blk) }
    end.call
  end

  def article_url(article, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end

  def server_url
    url_for :only_path => false, :controller => "/"
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
end

