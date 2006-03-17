require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase
  fixtures :users, :blogs

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = { :user => users(:tobi) }
  end

  def test_index
    get :index
    assert_rendered_file 'list'
    assert_template_has 'users'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'users'
  end

  def test_new
    get :new
    assert_rendered_file 'new'

    post :new, :user => { :login => 'errand', :email => 'corey@test.com',
      :password => 'testpass', :password_confirmation => 'testpass' }
    assert_redirected_to :action => 'list'
    follow_redirect
    assert_rendered_file 'list'
  end

  def test_show
    get :show, :id => 1
    assert_rendered_file 'show'
    assert_valid_record 'user'
  end

  def test_edit
    get :edit, :id => 1
    assert_rendered_file 'edit'
    assert_valid_record 'user'

    post :edit, :id => 1, :user => { :login => 'errand',
      :email => 'corey@test.com', :password => 'testpass',
      :password_confirmation => 'testpass' }
    assert_redirected_to :action => 'show'
    follow_redirect
    assert_rendered_file 'show'
    assert_valid_record 'user'
  end

  def test_destroy
    get :destroy, :id => 1
    assert_rendered_file 'destroy'
    assert_valid_record 'user'

    post :destroy, :id => 1
    assert_redirected_to :action => 'list'
    follow_redirect
    assert_rendered_file 'list'
  end

end
