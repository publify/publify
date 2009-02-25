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

  def test_redirect_from_articles_routing
    assert_routing "articles", {
      :from => ["articles"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo", {
      :from => ["articles", "foo"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo/bar", {
      :from => ["articles", "foo", "bar"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo/bar/baz", {
      :from => ["articles", "foo", "bar", "baz"],
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
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://myblog.net/2004/04/01/second-blog-article"
  end

  def test_url_root_redirect_articles
    b = blogs(:default)
    b.base_url = "http://test.host/blog"
    b.save
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/2004/04/01/second-blog-article"
  end

  def test_url_root_redirect_articles_when_url_root_is_articles
    b = blogs(:default)
    b.base_url = "http://test.host/articles"
    b.save
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/articles/2004/04/01/second-blog-article"
  end

  def test_url_root_redirect_articles_with_articles_in_url_root
    b = blogs(:default)
    b.base_url = "http://test.host/aaa/articles/bbb"
    b.save

    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/aaa/articles/bbb/2004/04/01/second-blog-article"
  end
end
