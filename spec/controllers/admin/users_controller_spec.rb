require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

describe Admin::UsersController, "rough port of the old functional test" do
  integrate_views
  fixtures :users

  describe ' when you are admin' do
    before(:each) do
      request.session = { :user => users(:tobi).id }
    end

    def test_index
      get :index
      assert_template 'index'
      assert_template_has 'users'
    end

    def test_new
      get :new
      assert_template 'new'

      post :new, :user => { :login => 'errand', :email => 'corey@test.com',
        :password => 'testpass', :password_confirmation => 'testpass', :profile_id => 1 }
      response.should redirect_to(:action => 'index')
    end

    def test_edit
      user_id = users(:tobi).id
      get :edit, :id => user_id
      assert_template 'edit'
      assert_valid assigns(:user)

      post :edit, :id => user_id, :user => { :login => 'errand',
        :email => 'corey@test.com', :password => 'testpass',
        :password_confirmation => 'testpass' }
      response.should redirect_to(:action => 'index')
    end

    it 'should edit himself if no params[:id]' do
      get :edit
      assert_template 'edit'
      assert_valid assigns(:user)

      post :edit, :user => { :login => 'errand',
        :email => 'corey@test.com', :password => 'testpass',
        :password_confirmation => 'testpass' }
      response.should redirect_to(:action => 'index')
    end

    def test_destroy
      user_count = User.count
      get :destroy, :id => users(:bob).id
      assert_template 'destroy'
      assert_valid assigns(:user)

      assert_equal user_count, User.count
      post :destroy, :id => users(:bob).id
      response.should redirect_to(:action => 'index')
      assert_equal user_count - 1, User.count
    end
  end

  describe 'when you are not admin' do

    before :each do
      session[:user] = users(:user_publisher).id
    end

    it "don't see the list of user" do
      get :index
      response.should redirect_to(:action => 'edit')
    end

    it 'become a Typo admin' do
      post :edit, :id => users(:user_publisher).id, :profile_id => profiles(:admin).id
      response.should redirect_to(:action => 'index')
    end
    
    it 'try update another user' do
      post :edit, :id => users(:tobi).id, :profile_id => profiles(:contributor).id
      response.should redirect_to(:action => 'index')
      u = users(:tobi).reload
      u.profile_id.should == profiles(:admin).id
    end
  end
end
