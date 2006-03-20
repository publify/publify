# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  include LoginSystem
  model :user

  before_filter { $blog = nil; $blog = this_blog }
  after_filter :flush_the_blog_object

  def article_url(article, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end

  def server_url
    url_for :only_path => false, :controller => "/"
  end

  def cache
    $cache ||= SimpleCache.new 1.hour
  end

  def flush_the_blog_object
    $blog = nil
    true
  end
end

require_dependency 'controllers/textfilter_controller'
