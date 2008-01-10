require File.dirname(__FILE__) + '/../spec_helper'

describe 'A successfully authenticated login' do
  controller_name :accounts

  before(:each) do
    @user = mock_model(User, :new_record? => false, :reload => @user)
    User.stub!(:authenticate).and_return(@user)
    User.stub!(:count).and_return(1)
    controller.stub!(:this_blot).and_return(Blog.default)
  end

  def make_request
    post 'login', { :user_login => 'bob', :password => 'test' }
  end

  it 'session gets a user' do
    User.should_receive(:authenticate).and_return(@user)
    make_request
    request.session[:user_id].should == @user.id
  end

  it 'cookies[:is_admin] should == "yes"' do
    make_request
    cookies['is_admin'].should == ['yes']
  end

  it 'redirects to /bogus/location' do
    request.session[:return_to] = '/bogus/location'
    make_request
#    post 'login', { :user_login => 'bob', :password => 'test' }
    response.should redirect_to('/bogus/location')
  end

  it "should redirect to signup if no users" do
    User.stub!(:count).and_return(0)
    make_request
    response.should redirect_to('/accounts/signup')
  end
end

describe 'Login gets the wrong password' do
  controller_name :accounts

  before(:each) do
    User.stub!(:authenticate).and_return(nil)
    User.stub!(:count).and_return(1)
  end

  def make_request
   post 'login', {:user_login => 'bob', :password => 'test'}
  end

  it 'no user in goes in the session' do
    make_request
    response.session[:user_id].should be_nil
  end

  it 'login should == "bob"' do
    make_request
    assigns[:login].should == 'bob'
  end

  it 'cookies[:is_admin] should be blank' do
    make_request
    response.cookies[:is_admin].should be_blank
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
    {'user' =>  {'login' => 'newbob', 'password' => 'newpassword',
        'password_confirmation' => 'newpassword'}}
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

  it 'redirects to /admin/settings' do
    post 'signup', params
    response.should redirect_to(:controller => 'admin/settings', :action => 'index')
  end

  it 'session gets a user' do
    post 'signup', params
    flash[:notice].should == 'Signup successful'
    request.session[:user_id].should == @user.id
  end

  it 'Sets the flash notice to "Signup successful"' do
    post 'signup', params
    flash[:notice].should == 'Signup successful'
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

    session[:user_id] = @user.id
    User.should_receive(:find) \
      .with(@user.id) \
      .any_number_of_times \
      .and_return(@user)

    request.cookies[:is_admin] = 'yes'
  end

  it 'logging out deletes the session[:user_id]' do
    get 'logout'
    session[:user_id].should == nil
  end

  it 'renders the logout action' do
    get 'logout'
    response.should render_template('logout')
  end

  it 'logging out deletes the "is_admin" cookie' do
    get 'logout'
    response.cookies[:is_admin].should be_blank
  end
end
