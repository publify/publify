require 'spec_helper'

describe Admin::UsersController, "rough port of the old functional test" do
  render_views

  describe ' when you are admin' do
    before(:each) do
      Factory(:blog)
            @admin = Factory(:user, :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => @admin.id }
    end

    it "test_index" do
      get :index
      assert_template 'index'
      assigns(:users).should_not be_nil
    end

    it "test_new" do
      get :new
      assert_template 'new'

      post :new, :user => { :login => 'errand', :email => 'corey@test.com',
        :password => 'testpass', :password_confirmation => 'testpass', :profile_id => 1, 
        :nickname => 'fooo', :firstname => 'bar' }
      response.should redirect_to(:action => 'index')
    end

    describe '#EDIT action' do

      describe 'with POST request' do
        it 'should redirect to index' do
          post :edit, :id => @admin.id, :user => { :login => 'errand',
            :email => 'corey@test.com', :password => 'testpass',
            :password_confirmation => 'testpass' }
          response.should redirect_to(:action => 'index')
        end
      end

      describe 'with GET request' do
        shared_examples_for 'edit admin render' do
          it 'should render template edit' do
            assert_template 'edit'
          end

          it 'should assigns tobi user' do
            assert assigns(:user).valid?
            assigns(:user).should == @admin 
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
            get :edit, :id => @admin.id
          end
          it_should_behave_like 'edit admin render'
        end

      end
  end

    it "test_destroy" do
      user_count = User.count
      get :destroy, :id => @admin.id
      assert_template 'destroy'
      assert assigns(:record).valid?

      user = Factory.build(:user)
      user.should_receive(:destroy)
      User.should_receive(:count).and_return(2)
      User.should_receive(:find).with(@admin.id).and_return(user)
      post :destroy, :id => @admin.id
      response.should redirect_to(:action => 'index')
    end
  end

  describe 'when you are not admin' do

    before :each do
      Factory(:blog)
      user = Factory(:user)
      session[:user] = user.id
    end

    it "don't see the list of user" do
      get :index
      response.should redirect_to(:controller => "/accounts", :action => "login")
    end

    describe 'EDIT Action' do

      describe 'try update another user' do
        before do
          @admin_profile = Factory.create(:profile_admin)
          @administrator = Factory.create(:user, :profile => @admin_profile)
          contributor = Factory.create(:profile_contributor)
          post :edit,
            :id => @administrator.id,
            :profile_id => contributor.id
        end

        it 'should redirect to login' do
          response.should redirect_to(:controller => "/accounts", :action => "login")
        end

        it 'should not change user profile' do
          u = @administrator.reload
          u.profile_id.should == @admin_profile.id
        end
      end
    end
  end
end
