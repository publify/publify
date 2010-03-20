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

describe 'GET setup with a configured blog and some users' do
  controller_name :setup

  it 'redirects to login' do
    get 'index'
    response.should redirect_to(:controller => 'articles', :action => 'index')
  end
end