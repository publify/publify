require File.dirname(__FILE__) + '/../spec_helper'

describe 'A successfully authenticated login' do
  controller_name :accounts

  before(:each) do
    @user = mock_model(User, :new_record? => false, :reload => @user)
    @user.stub!(:profile).and_return(Profile.find_by_label('admin'))
    User.stub!(:authenticate).and_return(@user)
    User.stub!(:find_by_id).with(@user.id).and_return(@user)
    User.stub!(:count).and_return(1)
    controller.stub!(:this_blog).and_return(Blog.default)
  end

  def make_request
    post 'login', {:user => {:login => 'bob', :password => 'test'}}
  end

  it 'session gets a user' do
    User.should_receive(:authenticate).and_return(@user)
    make_request
    request.session[:user_id].should == @user.id
  end

  it 'sets typo_user_profile cookie' do
    make_request
    cookies[:typo_user_profile].should == 'admin'
  end

  it 'redirects to /bogus/location' do
    request.session[:return_to] = '/bogus/location'
    make_request
    response.should redirect_to('/bogus/location')
  end
  
  it 'redirects to /admin if no return' do
    make_request
    response.should redirect_to(:controller => 'admin')
  end

  it 'redirects to /admin if no return and your are logged' do
    session[:user_id] = session[:user] = @user.id
    make_request
    response.should redirect_to(:controller => 'admin')
  end

  it "should redirect to signup if no users" do
    User.stub!(:count).and_return(0)
    make_request
    response.should redirect_to('/accounts/signup')
  end  
end

describe 'User is inactive' do
  controller_name :accounts

  before(:each) do
    User.stub!(:authenticate).and_return(nil)
    User.stub!(:count).and_return(1)
  end
 
  def make_request
    post 'login', {:user => {:login => 'inactive', :password => 'longtest'}}
  end
  
  it 'no user in goes in the session' do
    make_request
    response.session[:user_id].should be_nil
  end
  
  it 'login should == "inactive"' do
    make_request
    assigns[:login].should == 'inactive'
  end

  it 'typo_user_profile cookie should be blank' do
    make_request
    cookies[:typo_user_profile].should be_blank
  end

  it 'should render login action' do
    make_request
    response.should render_template(:login)
  end
  
end

describe 'Login with nil user and password' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(1)
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
  controller_name :accounts

  before(:each) do
    User.stub!(:authenticate).and_return(nil)
    User.stub!(:count).and_return(1)
  end

  def make_request
   post 'login', {:user => {:login => 'bob', :password => 'test'}}
  end

  it 'no user in goes in the session' do
    make_request
    response.session[:user_id].should be_nil
  end

  it 'login should == "bob"' do
    make_request
    assigns[:login].should == 'bob'
  end

  it 'typo_user_profile cookie should be blank' do
    make_request
    cookies[:typo_user_profile].should be_blank
  end

  it 'should render login action' do
    make_request
    response.should render_template(:login)
  end
end

describe 'GET /login' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(1)
  end

  it 'should render action :login' do
    get 'login'
    response.should render_template(:login)
    assigns[:login].should be_nil
  end
end

describe 'GET signup and >0 existing user' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(1)
  end

  it 'should redirect to login' do
    get 'signup'
    response.should redirect_to(:action => 'login')
  end
end

describe 'POST signup and >0 existing user' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(1)
  end

  it 'should redirect to login' do
    post 'signup', params
    response.should redirect_to(:action => 'login')
  end

  def params
    {'user' =>  {'login' => 'newbob'}}
  end
end

describe 'GET signup with 0 existing users' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(0)
    @user = mock("user")
    @user.stub!(:reload).and_return(@user)
    User.stub!(:new).and_return(@user)
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

describe 'POST signup with 0 existing users' do
  controller_name :accounts

  before(:each) do
    User.stub!(:count).and_return(0)
    @user = mock_model(User)
    @user.stub!(:login).and_return('newbob')
    @user.stub!(:password=).and_return(true)
    @user.stub!(:password).and_return('foo')
    @user.stub!(:name=).and_return(true)
    User.stub!(:new).and_return(@user)
    User.stub!(:authenticate).and_return(@user)
    @user.stub!(:save).and_return(@user)
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
  controller_name :accounts

  before(:each) do
    @user = mock_model(User)

    # The AccountsController class uses session[:user_id], and the
    # Typo LoginSystem uses session[:user].  So we need to set both of
    # these up correctly.  I'm not sure why the duplication exists.
    session[:user_id] = @user.id
    @controller.send(:current_user=, @user)

    User.should_receive(:find) \
      .with(:first, :conditions => { :id => @user.id }) \
      .any_number_of_times \
      .and_return(@user)

    cookies[:typo_user_profile] = 'admin'
  end

  it 'trying to log in once again redirects to admin/dashboard/index' do
    get 'login'
    response.should redirect_to(:controller => 'admin')
  end

  it 'logging out deletes the session[:user_id]' do
    @user.should_receive(:forget_me)
    get 'logout'
    session[:user_id].should be_blank
  end

  it 'redirects to the login action' do
    @user.should_receive(:forget_me)
    get 'logout'
    response.should redirect_to(:action => 'login')
  end

  it 'logging out deletes cookies containing credentials' do
    @user.should_receive(:forget_me)
    get 'logout'
    cookies[:auth_token].should == nil
    cookies[:typo_user_profile].should == nil
  end
end
