require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/blacklist_controller'

# Re-raise errors caught by the controller.
class Admin::BlacklistController; def rescue_action(e) raise e end; end

class Admin::BlacklistControllerTest < Test::Unit::TestCase
  fixtures :blacklist_patterns, :users

  def setup
    @controller = Admin::BlacklistController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'list'
  end

  def test_list
    get :list
    assert_template 'list'
    assert_template_has 'blacklist_patterns'
  end

  def test_create
    num_blacklist_patterns = BlacklistPattern.count

    post :new, 'blacklist_pattern' => { }
    assert_response :redirect, :action => 'list'

    assert_equal num_blacklist_patterns + 1, BlacklistPattern.count
  end

  def test_edit
    get :edit, 'id' => 1
    assert_template 'edit'
    assert_template_has('blacklist_pattern')
    assert_valid assigns(:blacklist_pattern)
  end

  def test_update
    post :edit, 'id' => 1
    assert_response :redirect, :action => 'list'
  end

  def test_destroy
    assert_not_nil BlacklistPattern.find(1)

    get :destroy, 'id' => 1
    assert_response :success

    post :destroy, 'id' => 1
    assert_response :redirect, :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      blacklist_pattern = BlacklistPattern.find(1)
    }
  end
end
