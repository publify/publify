require File.dirname(__FILE__) + '/../test_helper'
ActionController::Base.perform_caching = true

require 'articles_controller'
require 'page_cache'
require 'dns_mock'
require 'http_mock'
require 'set'



class CachingTest < Test::Unit::TestCase
  fixtures :contents, :categories, :settings, :users, :articles_categories, :text_filters, :articles_tags, :tags
  include ArticlesHelper
  
  def assert_cached(path)
    assert PageCache.find_by_name(path)
  end



  def setup
    @controller = ArticlesController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @controller.perform_caching = true

    # Complete settings fixtures
    config.reload
    PageCache.delete_all
  end

  def test_index
    get :index
    assert_response :success
    assert_rendered_file "index"
    assert_cached '/index.html'
    cache_entry = PageCache.find_by_name('/index.html')

    assert cache_entry.contributors.include?(contents(:article1))
  end

  def test_comment_caching
    get :permalink, :year => 2004, :month => '05', :day => '01', :title => 'inactive-article'

    entries = PageCache.find(:all)
    assert_equal(['/articles/2004/05/01/inactive-article.html'],
                 entries.collect {|i| i.name})
    assert_equal(2, entries.first.contributors.size)
    assert(entries.first.contributors.include?(contents(:inactive_article)))
    assert(entries.first.contributors.include?(contents(:old_comment)))  
  end
end
