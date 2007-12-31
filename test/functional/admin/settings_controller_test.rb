require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/settings_controller'

# Re-raise errors caught by the controller.
class Admin::SettingsController; def rescue_action(e) raise e end; end

class Admin::SettingsControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = Admin::SettingsController.new
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
    assert_response :redirect, :controller => 'admin/settings', :action => 'index'
  end
end