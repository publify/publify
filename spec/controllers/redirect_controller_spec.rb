require File.dirname(__FILE__) + '/../spec_helper'

describe RedirectController do
  before do
    ActionController::Base.relative_url_root = nil # avoid failures if environment.rb defines a relative URL root
  end

  it 'should split routing path' do
    assert_routing "foo/bar/baz", {
      :from => ["foo", "bar", "baz"],
      :controller => 'redirect', :action => 'redirect'}
  end

  it 'should redirect from articles_routing' do
    assert_routing "articles", {
      :from => ["articles"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo", {
      :from => ["articles", "foo"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo/bar", {
      :from => ["articles", "foo", "bar"],
      :controller => 'redirect', :action => 'redirect'}
    assert_routing "articles/foo/bar/baz", {
      :from => ["articles", "foo", "bar", "baz"],
      :controller => 'redirect', :action => 'redirect'}
  end


  it 'should redirect' do
    get :redirect, :from => ["foo", "bar"]
    assert_response 301
    assert_redirected_to "http://test.host/someplace/else"
  end

  it 'should redirect with url_root' do
    ActionController::Base.relative_url_root = "/blog"
    get :redirect, :from => ["foo", "bar"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/someplace/else"

    get :redirect, :from => ["bar", "foo"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/someplace/else"
  end

  it 'should no redirect' do
    get :redirect, :from => ["something/that/isnt/there"]
    assert_response 404
  end

  it 'should redirect to article' do
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://myblog.net/2004/04/01/second-blog-article"
  end

  it 'should redirect to article with url_root' do
    b = blogs(:default)
    b.base_url = "http://test.host/blog"
    b.save
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/blog/2004/04/01/second-blog-article"
  end

  it 'should redirect to article when url_root is articles' do
    b = blogs(:default)
    b.base_url = "http://test.host/articles"
    b.save
    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/articles/2004/04/01/second-blog-article"
  end

  it 'should redirect to article with articles in url_root' do
    b = blogs(:default)
    b.base_url = "http://test.host/aaa/articles/bbb"
    b.save

    get :redirect, :from => ["articles", "2004", "04", "01", "second-blog-article"]
    assert_response 301
    assert_redirected_to "http://test.host/aaa/articles/bbb/2004/04/01/second-blog-article"
  end

  describe 'render article' do

    integrate_views

    before(:each) do
      b = blogs(:default)
      b.permalink_format = '/%title%.html'
      b.save
      get :redirect, :from => ["#{contents(:article1).permalink}.html"]
    end

    it 'should render template read to article' do
      response.should render_template('articles/read.html.erb')
    end

    it 'should have good rss feed' do
      response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.rss")
    end

    it 'should have good atom feed' do
      response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.atom")
    end

  end

  describe 'with permalink_format like %title%.html' do

    integrate_views

    before(:each) do
      b = blogs(:default)
      b.permalink_format = '/%title%.html'
      b.save
    end
    describe 'render article' do

      integrate_views

      before(:each) do
        get :redirect, :from => ["#{contents(:article1).permalink}.html"]
      end

      it 'should render template read to article' do
        response.should render_template('articles/read.html.erb')
      end

      it 'should have good rss feed' do
        response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.rss")
      end

      it 'should have good atom feed' do
        response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.atom")
      end

    end

    it 'should get good article with utf8 title' do
      get :redirect, :from => ['2004', '06', '02', 'ルビー']
      assigns(:article).should == contents(:utf8_article)
    end

    describe 'render atom feed' do
      before(:each) do
        get :redirect, :from => ["#{contents(:article1).permalink}.html.atom"]
      end

      it 'should render atom partial' do
        response.should render_template('articles/_atom_feed.atom.builder')
      end
    end

    describe 'render rss feed' do
      before(:each) do
        get :redirect, :from => ["#{contents(:article1).permalink}.html.rss"]
      end

      it 'should render atom partial' do
        response.should render_template('articles/_rss20_feed.rss.builder')
      end
    end
  end
end
