require 'rails_helper'

describe AccountsController, type: :controller do
  describe "A successful login with 'Remember me' checked" do
    it 'should not cause password to change' do
      create(:blog)
      allow(User).to receive(:salt).and_return('change-me')
      henri = create(:user, login: 'henri', password: 'testagain')
      post 'login', user: { login: 'henri', password: 'testagain' }, remember_me: '1'
      expect(request.session[:user_id]).to eq(henri.id)
    end
  end

  describe 'A successfully authenticated login' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:salt).and_return('change-me')
      @henri = create(:user, login: 'henri', password: 'testagain', profile: create(:profile_admin, label: 'admin_henri'))
    end

    def make_request
      post 'login', user: { login: 'henri', password: 'testagain' }
    end

    it 'session gets a user' do
      make_request
      expect(request.session[:user_id]).to eq(@henri.id)
    end

    it 'sets publify_user_profile cookie' do
      make_request
      expect(cookies['publify_user_profile']).to eq('admin_henri')
    end

    it 'redirects to /bogus/location' do
      request.session[:return_to] = '/bogus/location'
      make_request
      expect(response).to redirect_to('/bogus/location')
    end

    it 'redirects to /admin if no return' do
      make_request
      expect(response).to redirect_to(controller: 'admin/dashboard')
    end

    it 'redirects to /admin if no return and you are logged in' do
      session[:user_id] = session[:user] = @henri.id
      make_request
      expect(response).to redirect_to(controller: 'admin/dashboard')
    end

    it 'should redirect to signup if no users' do
      allow(User).to receive(:count).and_return(0)
      make_request
      expect(response).to redirect_to('/accounts/signup')
    end
  end

  describe 'User is inactive' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:authenticate).and_return(nil)
      allow(User).to receive(:count).and_return(1)
    end

    def make_request
      post 'login', user: { login: 'inactive', password: 'longtest' }
    end

    it 'no user id goes in the session' do
      make_request
      expect(request.session[:user_id]).to be_nil
    end

    it 'login should == "inactive"' do
      make_request
      expect(assigns[:login]).to eq('inactive')
    end

    it 'publify_user_profile cookie should be blank' do
      make_request
      expect(cookies['publify_user_profile']).to be_blank
    end

    it 'should render login action' do
      make_request
      expect(response).to render_template(:login)
    end
  end

  describe 'Login with nil user and password' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:count).and_return(1)
    end

    def make_request
      post 'login', user: { login: nil, password: nil }
    end

    it 'should render login action' do
      make_request
      expect(response).to render_template(:login)
    end
  end

  describe 'Login gets the wrong password' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:authenticate).and_return(nil)
      allow(User).to receive(:count).and_return(1)
    end

    def make_request
      post 'login', user: { login: 'bob', password: 'test' }
    end

    it 'no user in goes in the session' do
      make_request
      expect(request.session[:user_id]).to be_nil
    end

    it 'login should == "bob"' do
      make_request
      expect(assigns[:login]).to eq('bob')
    end

    it 'publify_user_profile cookie should be blank' do
      make_request
      expect(cookies['publify_user_profile']).to be_blank
    end

    it 'should render login action' do
      make_request
      expect(response).to render_template(:login)
    end
  end

  describe 'GET /index' do
    let!(:blog) { create(:blog) }

    it 'should redirect to login' do
      allow(User).to receive(:count).and_return(1)
      get 'index'
      expect(response).to redirect_to(action: 'login')
    end

    it 'should redirect to signup' do
      allow(User).to receive(:count).and_return(0)
      get 'index'
      expect(response).to redirect_to(action: 'signup')
    end
  end

  describe 'GET /login' do
    it 'should render action :login' do
      create(:blog)
      allow(User).to receive(:count).and_return(1)
      get 'login'
      expect(response).to render_template(:login)
      expect(assigns[:login]).to be_nil
    end
  end

  describe 'GET /login with 0 existing users' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:count).and_return(0)
    end

    it 'should render action :signup' do
      get 'login'
      expect(response).to redirect_to(action: 'signup')
      expect(assigns[:login]).to be_nil
    end

    it 'should render :signup' do
      get 'recover_password'
      expect(response).to redirect_to(action: 'signup')
    end
  end

  describe 'with >0 existing user and allow_signup = 0' do
    before(:each) do
      @blog = create(:blog)
      allow(User).to receive(:count).and_return(1)
    end

    describe 'GET signup' do
      it 'should redirect to login' do
        get 'signup'
        expect(response).to redirect_to(action: 'login')
      end
    end

    describe 'POST signup without allow_signup' do
      it 'should redirect to login' do
        post 'signup', 'user' =>  { 'login' => 'newbob' }
        expect(response).to redirect_to(action: 'login')
      end
    end
  end

  describe 'with > 0 existing user and allow_signup = 1' do
    before(:each) do
      @blog = create(:blog, allow_signup: 1)
      allow(User).to receive(:count).and_return(1)
    end

    describe 'GET signup with allow_signup' do
      it 'should redirect to login' do
        get 'signup'
        expect(response).to render_template('signup')
      end
    end

    describe 'POST signup with allow_signup' do
      it 'should redirect to login' do
        post 'signup', 'user' =>  { 'login' => 'newbob', 'email' => 'newbob@mail.com' }
        expect(response).to redirect_to(action: 'confirm')
      end
    end
  end
  describe 'GET signup with 0 existing users' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:count).and_return(0)
      @user = double('user')
      allow(@user).to receive(:reload).and_return(@user)
      allow(User).to receive(:new).and_return(@user)
    end

    it 'sets @user' do
      get 'signup'
      expect(assigns[:user]).to eq(@user)
    end

    it 'renders action signup' do
      get 'signup'
      expect(response).to render_template(:signup)
    end
  end

  describe 'with 0 existing users and unconfigured blog' do
    before(:each) do
      Blog.delete_all
      @blog = Blog.new.save
      User.delete_all
    end

    describe 'when GET signup' do
      before { get 'signup' }
      it 'redirects to setup' do
        expect(response).to redirect_to(controller: 'setup', action: 'index')
      end
    end

    describe 'when POST signup' do
      before do
        post 'signup', 'user' =>  { 'login' => 'newbob', 'password' => 'newpassword',
                                    'password_confirmation' => 'newpassword' }
      end
      it 'redirects to setup' do
        expect(response).to redirect_to(controller: 'setup', action: 'index')
      end
    end

    describe 'when GET login' do
      before { get 'login' }
      it 'redirects to setup' do
        expect(response).to redirect_to(controller: 'setup', action: 'index')
      end
    end

    describe 'when POST login' do
      before do
        post 'login', 'user' =>  { 'login' => 'newbob', 'password' => 'newpassword' }
      end
      it 'redirects to setup' do
        expect(response).to redirect_to(controller: 'setup', action: 'index')
      end
    end
  end

  describe 'POST signup with 0 existing users' do
    before(:each) do
      create(:blog)
      allow(User).to receive(:count).and_return(0)
      @user = build_stubbed(User)
      allow(@user).to receive(:login).and_return('newbob')
      allow(@user).to receive(:generate_password!).and_return(true)
      allow(@user).to receive(:name=).and_return(true)
      allow(User).to receive(:new).and_return(@user)
      allow(User).to receive(:authenticate).and_return(@user)
      allow(@user).to receive(:save).and_return(@user)
    end

    it 'creates and saves a user' do
      expect(User).to receive(:new).and_return(@user)
      expect(@user).to receive(:save).and_return(@user)
      post 'signup', params
      expect(assigns[:user]).to eq(@user)
    end

    it 'redirects to /account/confirm' do
      post 'signup', params
      expect(response).to redirect_to(action: 'confirm')
    end

    it 'session gets a user' do
      post 'signup', params
      expect(request.session[:user_id]).to eq(@user.id)
    end

    def params
      { 'user' =>  { 'login' => 'newbob', 'password' => 'newpassword',
                     'password_confirmation' => 'newpassword' } }
    end
  end

  describe 'User is logged in' do
    before(:each) do
      create(:blog)
      @user = create(:user)

      # The AccountsController class uses session[:user_id], and the
      # Publify LoginSystem uses session[:user].  So we need to set both of
      # these up correctly.  I'm not sure why the duplication exists.
      session[:user_id] = @user.id
      session[:user] = @user.id

      cookies['publify_user_profile'] = 'admin'
    end

    it 'trying to log in once again redirects to admin/dashboard/index' do
      get 'login'
      expect(response).to redirect_to(controller: 'admin/dashboard')
    end

    describe 'when logging out' do
      before do
        get 'logout'
      end

      it 'deletes the session[:user_id]' do
        expect(session[:user_id]).to be_blank
      end

      it 'deletes the session[:user]' do
        expect(session[:user]).to be_blank
      end

      it 'redirects to the login action' do
        expect(response).to redirect_to(action: 'login')
      end

      it 'deletes cookies containing credentials' do
        expect(cookies['auth_token']).to eq(nil)
        expect(cookies['publify_user_profile']).to eq(nil)
      end
    end
  end

  describe '#recover_password' do
    let!(:blog) { create(:blog) }
    let!(:user) { create(:user, :as_admin) }

    context 'simply get' do
      before(:each) { get :recover_password }
      it { expect(response).to render_template('recover_password') }
    end

    context 'post' do
      before(:each) { post :recover_password, user: { login: user.login } }
      it { expect(response).to redirect_to(action: 'login') }
    end

    context 'post with an unknown login' do
      before(:each) { post :recover_password, user: { login: 'foobar' } }
      it { expect(response).to render_template('recover_password') }
      it { expect(flash[:error]).to eq(I18n.t('accounts.recover_password.error')) }
    end
  end
end
