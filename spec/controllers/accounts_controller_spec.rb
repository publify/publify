require File.dirname(__FILE__) + '/../spec_helper'

context 'A successfully authenticated login' do
  controller_name :accounts

  setup do
    @user = mock("user")
    @user.stub!(:new_record?).and_return(false)
    @user.stub!(:reload).and_return(@user)
    User.stub!(:authenticate).and_return(@user)
    post 'login', { :user_login => 'bob', :password => 'test' }
  end

  specify 'session gets a user' do
    request.session[:user].should == @user
  end

  specify 'cookies[:is_admin] should == "yes"' do
    cookies['is_admin'].should == ['yes']
  end

  specify 'redirects to /bogus/location' do
    request.session[:return_to] = '/bogus/location'
    controller.should_redirect_to '/bogus/location'
    post 'login', { :user_login => 'bob', :password => 'test' }
  end
end

context 'Login gets the wrong password' do
  controller_name :accounts

  setup do
    User.stub!(:authenticate).and_return(nil)
    post 'login', {:user_login => 'bob', :password => 'test'}
  end

  specify 'no user in goes in the session' do
    response.session[:user].should_be nil
  end

  specify 'login should == "bob"' do
    assigns[:login].should == 'bob'
  end

  specify 'cookies[:is_admin] should be blank' do
    response.cookies[:is_admin].should_be_blank
  end

  specify 'should render login action' do
    controller.should_render(:login)
    post 'login', {:user_login => 'bob', :password => 'test'}
  end
end

context 'GET /login' do
  controller_name :accounts

  specify 'should render action :login' do
    controller.should_render(:login)
    get 'login'
    assigns[:login].should_be_nil
  end
end

context 'GET signup and >0 existing user' do
  controller_name :accounts

  setup do
    User.stub!(:count).and_return(1)
  end

  specify 'should redirect to login' do
    controller.should_redirect_to :action => 'login'
    get 'signup'
  end
end

context 'POST signup and >0 existing user' do
  controller_name :accounts

  setup do
    User.stub!(:count).and_return(1)
  end

  specify 'should redirect to login' do
    controller.should_redirect_to :action => 'login'
    post 'signup', params
  end

  def params
    {'user' =>  {'login' => 'newbob', 'password' => 'newpassword',
        'password_confirmation' => 'newpassword'}}
  end
end

context 'GET signup with 0 existing users' do
  controller_name :accounts

  setup do
    User.stub!(:count).and_return(0)
    @user = mock("user")
    @user.stub!(:reload).and_return(@user)
    User.stub!(:new).and_return(@user)
  end

  specify 'sets @user' do
    get 'signup'
    assigns[:user].should == @user
  end

  specify 'renders action signup' do
    controller.should_render :signup
    get 'signup'
  end
end

context 'POST signup with 0 existing users' do
  controller_name :accounts

  setup do
    User.stub!(:count).and_return(0)
    @user = mock("user")
    @user.stub!(:reload).and_return(@user)
    @user.stub!(:login).and_return('newbob')
    User.stub!(:new).and_return(@user)
    User.stub!(:authenticate).and_return(@user)
    @user.stub!(:save).and_return(@user)
  end

  specify 'creates and saves a user' do
    User.should_receive(:new).and_return(@user)
    @user.should_receive(:save).and_return(@user)
    post 'signup', params
    assigns[:user].should == @user
  end

  specify 'redirects to /admin/general' do
    controller.should_redirect_to :controller => 'admin/general', :action => 'index'
    post 'signup', params
  end

  specify 'session gets a user' do
    post 'signup', params
    flash[:notice].should == 'Signup successful'
    request.session[:user].should == @user
  end

  specify 'Sets the flash notice to "Signup successful"' do
    post 'signup', params
    flash[:notice].should == 'Signup successful'
  end

  def params
    {'user' =>  {'login' => 'newbob', 'password' => 'newpassword',
        'password_confirmation' => 'newpassword'}}
  end
end

context 'User is logged in' do
  controller_name :accounts

  setup do
    @user = mock('user')

    session[:user] = @user
    @user.stub!(:reload).and_return(@user)
    request.cookies[:is_admin] = 'yes'
  end

  specify 'logging out deletes the session[:user]' do
    get 'logout'
    session[:user].should == nil
  end

  specify 'renders the logout action' do
    controller.should_render :logout
    get 'logout'
  end

  specify 'logging out deletes the "is_admin" cookie' do
    get 'logout'
    response.cookies[:is_admin].should_be_blank
  end
end
