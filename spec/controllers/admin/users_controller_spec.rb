require File.dirname(__FILE__) + '/../../spec_helper'

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

    describe '#EDIT action' do
      describe 'with POST request' do
        before do
          post :edit, :id => users(:tobi).id, :user => { :login => 'errand',
            :email => 'corey@test.com', :password => 'testpass',
            :password_confirmation => 'testpass' }
        end
        it 'should redirect to index' do
          response.should redirect_to(:action => 'index')
        end
      end

      describe 'with GET request' do
        describe 'edit admin render', :shared => true do
          it 'should render template edit' do
            assert_template 'edit'
          end

          it 'should assigns tobi user' do
            assert assigns(:user).valid?
            assigns(:user).should == users(:tobi)
          end
        end
        describe 'with no id params' do
          before do
            get :edit
          end
          it_should_behave_like 'edit admin render'
        end

        describe 'with id params' do
          before do
            get :edit, :id => users(:tobi).id
          end
          it_should_behave_like 'edit admin render'
        end

      end
    end

    def test_destroy
      user_count = User.count
      get :destroy, :id => users(:bob).id
      assert_template 'destroy'
      assert assigns(:user).valid?

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
      response.should redirect_to('/accounts/login')
    end

    describe 'EDIT Action' do

      describe 'try update another user' do
        before do
          post :edit,
            :id => users(:tobi).id,
            :profile_id => profiles(:contributor).id
        end
        it 'should redirect to login' do
          response.should redirect_to('/accounts/login')
        end
        it 'should not change user profile' do
          u = users(:tobi).reload
          u.profile_id.should == profiles(:admin).id
        end
      end
    end
  end
end
