require 'spec_helper'

describe AccountsController do
  describe "A successful login with 'Remember me' checked" do
    it 'should not cause password to change' do
      FactoryGirl.create(:blog)
      User.stub(:salt).and_return('change-me')
      henri = FactoryGirl.create(:user, :login => 'henri', :password => 'testagain')
      post 'login', {:user => {:login => 'henri', :password => 'testagain'}, :remember_me => '1'}
      request.session[:user_id].should == henri.id
    end
  end

  describe 'A successfully authenticated login' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:salt).and_return('change-me')
      @henri = FactoryGirl.create(:user, :login => 'henri', :password => 'testagain', :profile => FactoryGirl.create(:profile_admin, :label => 'admin_henri'))
    end

    def make_request
      post 'login', {:user => {:login => 'henri', :password => 'testagain'}}
    end

    it 'session gets a user' do
      make_request
      request.session[:user_id].should == @henri.id
    end

    it 'sets typo_user_profile cookie' do
      make_request
      cookies["typo_user_profile"].should == 'admin_henri'
    end

    it 'redirects to /bogus/location' do
      request.session[:return_to] = '/bogus/location'
      make_request
      response.should redirect_to('/bogus/location')
    end

    it 'redirects to /admin if no return' do
      make_request
      response.should redirect_to(:controller => 'admin/dashboard')
    end

    it 'redirects to /admin if no return and you are logged in' do
      session[:user_id] = session[:user] = @henri.id
      make_request
      response.should redirect_to(:controller => 'admin/dashboard')
    end

    it "should redirect to signup if no users" do
      User.stub(:count).and_return(0)
      make_request
      response.should redirect_to('/accounts/signup')
    end
  end

  describe 'User is inactive' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:authenticate).and_return(nil)
      User.stub(:count).and_return(1)
    end

    def make_request
      post 'login', {:user => {:login => 'inactive', :password => 'longtest'}}
    end

    it 'no user id goes in the session' do
      make_request
      request.session[:user_id].should be_nil
    end

    it 'login should == "inactive"' do
      make_request
      assigns[:login].should == 'inactive'
    end

    it 'typo_user_profile cookie should be blank' do
      make_request
      cookies["typo_user_profile"].should be_blank
    end

    it 'should render login action' do
      make_request
      response.should render_template(:login)
    end

  end

  describe 'Login with nil user and password' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(1)
    end

    def make_request
      post 'login', {:user => {:login => nil, :password => nil}}
    end

    it 'should render login action' do
      make_request
      response.should render_template(:login)
    end
  end

  describe 'Login gets the wrong password' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:authenticate).and_return(nil)
      User.stub(:count).and_return(1)
    end

    def make_request
      post 'login', {:user => {:login => 'bob', :password => 'test'}}
    end

    it 'no user in goes in the session' do
      make_request
      request.session[:user_id].should be_nil
    end

    it 'login should == "bob"' do
      make_request
      assigns[:login].should == 'bob'
    end

    it 'typo_user_profile cookie should be blank' do
      make_request
      cookies["typo_user_profile"].should be_blank
    end

    it 'should render login action' do
      make_request
      response.should render_template(:login)
    end
  end

  describe 'GET /index' do
    it 'should redirect to login' do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(1)
      get 'index'
      response.should redirect_to(:action => 'login')
    end

    it 'should redirect to signup' do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(0)
      get 'index'
      response.should redirect_to(:action => 'signup')
    end
  end

  describe 'GET /login' do
    it 'should render action :login' do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(1)
      get 'login'
      response.should render_template(:login)
      assigns[:login].should be_nil
    end
  end

  describe 'GET /login with 0 existing users' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(0)
    end

    it 'should render action :signup' do
      get 'login'
      response.should redirect_to(:action => 'signup')
      assigns[:login].should be_nil
    end

    it 'should render :signup' do
      get 'recover_password'
      response.should redirect_to(:action => 'signup')
    end
  end

  describe 'with >0 existing user and allow_signup = 0' do
    before(:each) do
      @blog = FactoryGirl.create(:blog)
      User.stub(:count).and_return(1)
    end

    describe 'GET signup' do
      it 'should redirect to login' do
        get 'signup'
        response.should redirect_to(:action => 'login')
      end
    end

    describe 'POST signup without allow_signup' do
      it 'should redirect to login' do
        post 'signup', {'user' =>  {'login' => 'newbob'}}
        response.should redirect_to(:action => 'login')
      end
    end
  end

  describe 'with > 0 existing user and allow_signup = 1' do
    before(:each) do
      @blog = FactoryGirl.create(:blog, :allow_signup => 1)
      User.stub(:count).and_return(1)
    end

    describe 'GET signup with allow_signup' do
      it 'should redirect to login' do
        get 'signup'
        response.should render_template('signup')
      end
    end

    describe 'POST signup with allow_signup' do
      it 'should redirect to login' do
        post 'signup', {'user' =>  {'login' => 'newbob', 'email' => 'newbob@mail.com'}}
        response.should redirect_to(:action => 'confirm')
      end
    end

  end
  describe 'GET signup with 0 existing users' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(0)
      @user = mock("user")
      @user.stub(:reload).and_return(@user)
      User.stub(:new).and_return(@user)
    end

    it 'sets @user' do
      get 'signup'
      assigns[:user].should == @user
    end

    it 'renders action signup' do
      get 'signup'
      response.should render_template(:signup)
    end
  end

  describe "with 0 existing users and unconfigured blog" do
    before(:each) do
      Blog.delete_all
      @blog = Blog.new.save
      User.delete_all
    end

    describe 'when GET signup' do
      before { get 'signup' }
      it 'redirects to setup' do
        response.should redirect_to(:controller => 'setup', :action => 'index')
      end
    end

    describe 'when POST signup' do
      before do
        post 'signup', {'user' =>  {'login' => 'newbob', 'password' => 'newpassword',
          'password_confirmation' => 'newpassword'}}
      end
      it 'redirects to setup' do
        response.should redirect_to(:controller => 'setup', :action => 'index')
      end
    end

    describe 'when GET login' do
      before { get 'login' }
      it 'redirects to setup' do
        response.should redirect_to(:controller => 'setup', :action => 'index')
      end
    end

    describe 'when POST login' do
      before do
        post 'login', {'user' =>  {'login' => 'newbob', 'password' => 'newpassword'}}
      end
      it 'redirects to setup' do
        response.should redirect_to(:controller => 'setup', :action => 'index')
      end
    end
  end

  describe 'POST signup with 0 existing users' do
    before(:each) do
      FactoryGirl.create(:blog)
      User.stub(:count).and_return(0)
      @user = mock_model(User)
      @user.stub(:login).and_return('newbob')
      @user.stub(:generate_password!).and_return(true)
      @user.stub(:name=).and_return(true)
      User.stub(:new).and_return(@user)
      User.stub(:authenticate).and_return(@user)
      @user.stub(:save).and_return(@user)
    end

    it 'creates and saves a user' do
      User.should_receive(:new).and_return(@user)
      @user.should_receive(:save).and_return(@user)
      post 'signup', params
      assigns[:user].should == @user
    end

    it 'redirects to /account/confirm' do
      post 'signup', params
      response.should redirect_to(:action => 'confirm')
    end

    it 'session gets a user' do
      post 'signup', params
      request.session[:user_id].should == @user.id
    end

    def params
      {'user' =>  {'login' => 'newbob', 'password' => 'newpassword',
  'password_confirmation' => 'newpassword'}}
    end
  end

  describe 'User is logged in' do
    before(:each) do
      FactoryGirl.create(:blog)
      @user = FactoryGirl.create(:user)

      # The AccountsController class uses session[:user_id], and the
      # Typo LoginSystem uses session[:user].  So we need to set both of
      # these up correctly.  I'm not sure why the duplication exists.
      session[:user_id] = @user.id
      session[:user] = @user.id

      cookies["typo_user_profile"] = 'admin'
    end

    it 'trying to log in once again redirects to admin/dashboard/index' do
      get 'login'
      response.should redirect_to(:controller => 'admin/dashboard')
    end

    describe "when logging out" do
      before do
        get 'logout'
      end

      it 'deletes the session[:user_id]' do
        session[:user_id].should be_blank
      end

      it 'deletes the session[:user]' do
        session[:user].should be_blank
      end

      it 'redirects to the login action' do
        response.should redirect_to(:action => 'login')
      end

      it 'deletes cookies containing credentials' do
        cookies["auth_token"].should == nil
        cookies["typo_user_profile"].should == nil
      end
    end
  end

  describe 'when user has lost their password' do
    before(:each) do
      FactoryGirl.create(:blog)
      @user = FactoryGirl.create(:user)
      @user.profile = Profile.find_by_label('admin')
    end

    describe 'when GET' do
      before { get 'recover_password' }

      specify { response.should render_template('recover_password') }
    end

    describe 'when a known login or email is POSTed' do
      before do
        post 'recover_password', {:user => {:login => @user.login}}
      end
      specify { response.should redirect_to(:action => 'login') }
    end

    describe 'when an unknown login or email is POSTed' do
      before do
        post 'recover_password', {:user => {:login => 'foobar'}}
      end

      specify { response.should render_template('recover_password') }
      it "should display an error" do
        request.flash[:error].should_not be_empty
      end
    end
  end
end
