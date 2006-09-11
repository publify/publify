require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

require 'content'

# Reraise errors caught by the controller
class ArticlesController; def rescue_action(e) raise e end; end

class ContentFragmentCacheTest < Test::Unit::TestCase
  fixtures :contents, :categories, :blogs, :users, :articles_categories, :text_filters, :articles_tags, :tags

  def setup
    @controller = ArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user => users(:tobi) }

    Sidebar.delete_all
    turn_on_memory_caching
  end

  def test_read_caches_full_article
    get :permalink, :year => 2004, :month => 06, :day => 01, :title => 'article-3'
    assert_response :success
    assert_caches contents(:article3)
  end

  def test_read_caches_article_comments
    get :read, :id => contents(:article1).id
    assert_response :success

    assert_caches contents(:article1)

    Article.find(contents(:article1).id).published_comments.each do |c|
      assert_caches c
    end
  end

  def assert_caches(content, what = :all)
    assert_not_nil(@controller.read_fragment(content.cache_key(what)))
  end

  def assert_uncached(content, what = :all)
    assert_nil @controller.read_fragment(content.cache_key(what))
  end

  def teardown
    turn_off_memory_caching
  end

  def turn_on_memory_caching
    @old_fragment_cache  = ActionController::Base.fragment_cache_store
    @old_perform_caching = ActionController::Base.perform_caching

    ActionController::Base.fragment_cache_store = :memory_store
    ActionController::Base.perform_caching      = true
  end

  def turn_off_memory_caching
    ActionController::Base.fragment_cache_store = @old_fragment_cache
    ActionController::Base.perform_caching      = @old_perform_caching
  end
end
