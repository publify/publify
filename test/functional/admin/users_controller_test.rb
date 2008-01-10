require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index
    assert_template 'list'
    assert_template_has 'users'
  end

  def test_list
    get :list
    assert_template 'list'
    assert_template_has 'users'
  end

  def test_new
    get :new
    assert_template 'new'

    post :new, :user => { :login => 'errand', :email => 'corey@test.com',
      :password => 'testpass', :password_confirmation => 'testpass' }
    assert_response :redirect, :action => 'list'
    follow_redirect
    assert_template 'list'
  end

  def test_show
    get :show, :id => 1
    assert_template 'show'
    assert_valid assigns(:user)

    assert_template_has 'user'
    assert_template_has 'articles'
  end

  def test_edit
    get :edit, :id => 1
    assert_template 'edit'
    assert_valid assigns(:user)

    post :edit, :id => 1, :user => { :login => 'errand',
      :email => 'corey@test.com', :password => 'testpass',
      :password_confirmation => 'testpass' }
    assert_response :redirect, :action => 'show'
    follow_redirect
    assert_template 'show'
    assert_valid assigns(:user)
  end

  def test_destroy
    user_count = User.count
    get :destroy, :id => users(:bob).id
    assert_template 'destroy'
    assert_valid assigns(:user)

    assert_equal user_count, User.count
    post :destroy, :id => users(:bob).id
    assert_response :redirect, :action => 'list'
    follow_redirect
    assert_template 'list'
    assert_equal user_count - 1, User.count
  end

end
