require 'spec_helper'

describe AuthorsController do
  render_views

  describe 'show action' do
    before :each do
      Factory(:blog)
      get 'show', :id => 'tobi'
    end

    it 'should be render template index' do
      response.should render_template(:show)
    end

    it 'should assigns articles' do
      assigns[:author].should_not be_nil
    end

    it 'should have good link feed rss' do
      response.should have_selector('head>link[href="http://test.host/author/tobi.rss"]')
    end

    it 'should have good link feed atom' do
      response.should have_selector('head>link[href="http://test.host/author/tobi.atom"]')
    end
  end

  specify "/author/tobi.atom => an atom feed" do
    Factory(:blog)
    user = Factory(:user, :name => 'tobi')
    article = Factory(:article, :user => user)
    get 'show', :id => user.login, :format => 'atom'
    response.should be_success
    response.should render_template("shared/_atom_feed")
    assert_feedvalidator @response.body
  end

  specify "/author/tobi.rss => a rss feed" do
    Factory(:blog)
    get 'show', :id => 'tobi', :format => 'rss'
    response.should be_success
    response.should render_template("shared/_rss20_feed")
    response.should have_selector('link', :content => 'http://myblog.net')
    assert_feedvalidator @response.body
  end
end

describe AuthorsController, "SEO options" do
  render_views

  before :each do
    @blog = Factory(:blog, :use_meta_keyword => false)
  end

  it 'should never have meta keywords with deactivated option' do
    get 'show', :id => 'tobi'
    
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should never have meta keywords with deactivated option' do
    @blog.use_meta_keyword = true
    @blog.save
    get 'show', :id => 'tobi'
    
    response.should_not have_selector('head>meta[name="keywords"]')
  end

end
