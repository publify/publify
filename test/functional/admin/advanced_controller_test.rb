require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/advanced_controller'

# Re-raise errors caught by the controller.
class Admin::AdvancedController; def rescue_action(e) raise e end; end

class Admin::AdvancedControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = Admin::AdvancedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'index'
  end
end