require File.dirname(__FILE__) + '/../test_helper'
require 'redirect_controller'

# Re-raise errors caught by the controller.
class RedirectController; def rescue_action(e) raise e end; end

class RedirectControllerTest < Test::Unit::TestCase
  fixtures :redirects

  def setup
    @controller = RedirectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_redirect
    get :redirect, :from => "foo/bar"
    assert_response 301
    assert_redirected_to "/someplace/else"
  end

  def test_no_redirect
    get :redirect, :from => "something/that/isnt/there"
    assert_response 404
  end
end
