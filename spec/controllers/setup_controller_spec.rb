require File.dirname(__FILE__) + '/../spec_helper'

describe 'GET setup with no configured blog' do
  controller_name :setup

  before(:each) do
    Blog.delete_all
    @blog = Blog.new.save
  end

  it 'renders index' do
    get 'index'
    response.should render_template('index')
  end
end

describe 'GET setup with a configured blog and no user' do
  controller_name :setup

  before(:each) do
    User.stub!(:count).and_return(0)
    @user = mock("user")
    @user.stub!(:reload).and_return(@user)
    User.stub!(:new).and_return(@user)
    
  end

  it 'redirects to setup' do
    get 'index'
    response.should redirect_to(:controller => 'accounts', :action => 'signup')
  end
end

describe 'GET setup with a configured blog and some users' do
  controller_name :setup

  it 'redirects to login' do
    get 'index'
    response.should redirect_to(:controller => 'articles', :action => 'index')
  end
end