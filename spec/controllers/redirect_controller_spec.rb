require File.dirname(__FILE__) + '/../../test/test_helper'
require File.dirname(__FILE__) + '/../spec_helper'
require 'redirect_controller'

# Re-raise errors caught by the controller.
class RedirectController; def rescue_action(e) raise e end; end

describe RedirectController do
  before do
    ActionController::Base.relative_url_root = nil # avoid failures if environment.rb defines a relative URL root
  end

  def test_routing_splits_path
    assert_routing "foo/bar/baz", {
      :from => ["foo", "bar", "baz"],
      :controller => 'redirect', :action => 'redirect'}
  end

  def test_redirect
    get :redirect, :from => ["foo", "bar"]
    assert_response 301
    assert_redirected_to "http://test.host/someplace/else"
  end

  def test_url_root_redirect
    ActionController::Base.relative_url_root = "/blog"
    get :redirect, :from => ["foo", "bar"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/someplace/else"

    get :redirect, :from => ["bar", "foo"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/someplace/else"
  end

  def test_no_redirect
    get :redirect, :from => ["something/that/isnt/there"]
    assert_response 404
  end

  def test_redirect_articles
    get :redirect, :from => ["articles", "foo", "bar", "baz"]
    assert_response 301
    assert_redirected_to "http://test.host/foo/bar/baz"
  end

  def test_redirect_articles_with_articles_in_path
    get :redirect, :from => ["articles", "foo", "articles", "baz"]
    assert_response 301
    assert_redirected_to "http://test.host/foo/articles/baz"
  end

  def test_url_root_redirect_articles
    ActionController::Base.relative_url_root = "/blog"
    get :redirect, :from => ["articles", "foo", "bar", "baz"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/foo/bar/baz"
  end

  def test_url_root_redirect_articles_when_url_root_is_articles
    ActionController::Base.relative_url_root = "/articles"
    get :redirect, :from => ["articles", "foo", "bar", "baz"]
    assert_response 301
    assert_redirected_to "http://test.host/articles/foo/bar/baz"
  end

  def test_url_root_redirect_articles_with_articles_in_url_root
    ActionController::Base.relative_url_root = "/aaa/articles/bbb"
    get :redirect, :from => ["articles", "foo", "bar", "baz"]
    assert_response 301
    assert_redirected_to "http://test.host/aaa/articles/bbb/foo/bar/baz"
  end
end
