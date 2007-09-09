require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/general_controller'

# Re-raise errors caught by the controller.
class Admin::GeneralController; def rescue_action(e) raise e end; end

class Admin::GeneralControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = Admin::GeneralController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
  end

  def test_redirect
    get :redirect
    assert_response :redirect, :controller => 'admin/general', :action => 'index'
  end
end
