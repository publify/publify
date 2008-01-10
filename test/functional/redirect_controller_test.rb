require File.dirname(__FILE__) + '/../test_helper'
require 'redirect_controller'

# Re-raise errors caught by the controller.
class RedirectController; def rescue_action(e) raise e end; end

class RedirectControllerTest < Test::Unit::TestCase
  def setup
    @controller = RedirectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.relative_url_root = nil # avoid failures if environment.rb defines a relative URL root
  end

  # Replace this with your real tests.
  def test_redirect
    get :redirect, :from => "foo/bar"
    assert_response 301
    assert_response :redirect, "/someplace/else"
  end

  def test_url_root_redirect
    @request.relative_url_root = "/blog"
    get :redirect, :from => "foo/bar"
    assert_response 301
    assert_response :redirect, "/blog/someplace/else"
    
    get :redirect, :from => "bar/foo"
    assert_response 301
    assert_response :redirect, "/blog/someplace/else"
  end

  def test_no_redirect
    get :redirect, :from => "something/that/isnt/there"
    assert_response 404
  end
end
