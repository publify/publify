require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  integrate_views

  it "should redirect category to /categories" do
    get 'category'
    response.should redirect_to(categories_path)
  end

  it "should redirect tag to /tags" do
    get 'tag'
    response.should redirect_to(tags_path)
  end

  describe 'index action' do
    before :each do
      get 'index'
    end

    it 'should be render template index' do
      response.should render_template(:index)
    end

    it 'should assigns articles' do
      assigns[:articles].should_not be_nil
    end

    it 'should have good link feed rss' do
      response.should have_tag('head>link[href=?]','http://test.host/articles.rss')
    end

    it 'should have good link feed atom' do
      response.should have_tag('head>link[href=?]','http://test.host/articles.atom')
    end
  end


  describe '#search action' do

    describe 'a valid search' do
      before :each do
        get 'search', :q => 'a'
      end

      it 'should render template search' do
        response.should render_template(:search)
      end

      it 'should assigns articles' do
        assigns[:articles].should_not be_nil
      end

      it 'should have good feed rss link' do
        response.should have_tag('head>link[href=?]','http://test.host/search/a.rss')
      end

      it 'should have good feed atom link' do
        response.should have_tag('head>link[href=?]','http://test.host/search/a.atom')
      end

      it 'should have content markdown interpret and without html tag' do
        response.should have_tag('div', /in markdown format\n\n\nwe\nuse\nok to define a link\n\n...\n/)
      end

    end

    it 'should render feed rss by search' do
      get 'search', :q => 'a', :format => 'rss'
      response.should be_success
      response.should render_template('articles/_rss20_feed')
      assert_feedvalidator response.body
    end

    it 'should render feed atom by search' do
      get 'search', :q => 'a', :format => 'atom'
      response.should be_success
      response.should render_template('articles/_atom_feed')
      assert_feedvalidator response.body
    end

    it 'search with empty result' do
      get 'search', :q => 'abcdefghijklmnopqrstuvwxyz'
      response.should render_template('articles/error.html.erb')
      assigns[:articles].should be_empty
    end
  end

  describe '#livesearch action' do

    describe 'with a query with several words' do

      before :each do
        Factory.create(:article, :body => "hello world and im herer")
        Factory.create(:article, :title => "hello", :body => "worldwide")
        Factory.create(:article)
        get :live_search, :q => 'hello world'
      end

      it 'should be valid' do 
        assigns[:articles].should_not be_empty
        assigns[:articles].should have(2).records
      end

      it 'should render without layout' do
        controller.should_receive(:render).with(:layout =>false, :action => :live_search)
        get :live_search, :q => 'hello world'
      end

      it 'should render template live_search' do
        response.should render_template(:live_search)
      end

      it 'should not have h3 tag' do
        response.should have_tag("h3")
      end

      it "should assign @search the search string" do
        assigns[:search].should be_equal(params[:q])
      end

    end
  end

  
  it 'archives' do
    get 'archives'
    response.should render_template(:archives)
    assigns[:articles].should_not be_nil
  end

  describe 'index for a month' do

    before :each do
      get 'index', :year => 2004, :month => 4
    end

    it 'should render template index' do
      response.should render_template(:index)
    end

    it 'should contain some articles' do
      assigns[:articles].should_not be_nil
    end
  end

end

describe ArticlesController, "nosettings" do
  before(:each) do
    Blog.delete_all
    @blog = Blog.new.save
  end

  it 'redirects to setup' do
    get 'index'
    response.should redirect_to(:controller => 'setup', :action => 'index')
  end
  
end

describe ArticlesController, "nousers" do
  before(:each) do
    User.stub!(:count).and_return(0)
    @user = mock("user")
    @user.stub!(:reload).and_return(@user)
    User.stub!(:new).and_return(@user)
  end

  it 'redirects to signup' do
    get 'index'
    response.should redirect_to(:controller => 'accounts', :action => 'signup')
  end
end

describe ArticlesController, "feeds" do
  
  integrate_views

  specify "/articles.atom => an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("_atom_feed")
    assert_feedvalidator response.body
  end

  specify "/articles.rss => an RSS 2.0 feed" do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("_rss20_feed")
    response.should have_tag('link', 'http://myblog.net')
    assert_feedvalidator response.body
  end

  specify "atom feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'atom'
    response.should render_template("_atom_feed")
    assert_feedvalidator response.body
  end

  specify "RSS feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'rss'
    response.should render_template("_rss20_feed")
    assert_feedvalidator response.body
  end

  it 'should create valid atom feed when article contains &eacute;' do
    article = contents(:article2)
    article.body = '&eacute;coute!'
    article.save!
    get 'index', :format => 'atom'
    #response.body.should =~ /écoute!/
    assert_feedvalidator response.body
  end

  it 'should create valid atom feed when article contains loose <' do
    article = contents(:article2)
    article.body = 'is 4 < 2? no!'
    article.save!
    get 'index', :format => 'atom'
    assert_feedvalidator response.body
  end
end

describe ArticlesController, "the index" do
  it "should ignore the HTTP Accept: header" do
    request.env["HTTP_ACCEPT"] = "application/atom+xml"
    get "index"
    response.should_not render_template("_atom_feed")
  end
end

describe ArticlesController, "previewing" do
  integrate_views

  describe 'with non logged user' do
    before :each do
      @request.session = {}
      get :preview, :id => Factory(:article).id
    end

    it 'should be redirect to login' do
      response.should redirect_to(:controller => "accounts/login", :action => :index)
    end
  end
  describe 'with logged user' do
    before :each do
      @request.session = {:user => users(:tobi).id}
      @article = Factory(:article)
    end

    with_each_theme do |theme, view_path|
      it "should render template #{view_path}/articles/read" do
        this_blog.theme = theme if theme
        get :preview, :id => @article.id
        response.should render_template('articles/read.html.erb')
      end
    end

    it 'should assigns article define with id' do
      get :preview, :id => @article.id
      assigns[:article].should == @article
    end

    it 'should assigns last article with id like parent_id' do
      draft = Factory(:article, :parent_id => @article.id)
      get :preview, :id => @article.id
      assigns[:article].should == draft
    end

  end
end

describe ArticlesController, "redirecting" do
  before do
    ActionController::Base.relative_url_root = nil # avoid failures if environment.rb defines a relative URL root
  end

  it 'should split routing path' do
    assert_routing "foo/bar/baz", {
      :from => ["foo", "bar", "baz"],
      :controller => 'articles', :action => 'redirect'}
  end

  it 'should redirect from articles_routing' do
    assert_routing "articles", {
      :from => ["articles"],
      :controller => 'articles', :action => 'redirect'}
    assert_routing "articles/foo", {
      :from => ["articles", "foo"],
      :controller => 'articles', :action => 'redirect'}
    assert_routing "articles/foo/bar", {
      :from => ["articles", "foo", "bar"],
      :controller => 'articles', :action => 'redirect'}
    assert_routing "articles/foo/bar/baz", {
      :from => ["articles", "foo", "bar", "baz"],
      :controller => 'articles', :action => 'redirect'}
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

      it 'should assign article1 to @article' do
	assigns(:article).should == contents(:article1)
      end

      it 'should have good rss feed link' do
        response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.rss")
      end

      it 'should have good atom feed link' do
        response.should have_tag('head>link[href=?]', "http://myblog.net/#{contents(:article1).permalink}.html.atom")
      end

    end

    it 'should get good article with utf8 slug' do
      get :redirect, :from => ['2004', '06', '02', 'ルビー']
      assigns(:article).should == contents(:utf8_article)
    end

    describe 'rendering as atom feed' do
      before(:each) do
        get :redirect, :from => ["#{contents(:article1).permalink}.html.atom"]
      end

      it 'should render atom partial' do
        response.should render_template('articles/_atom_feed.atom.builder')
      end

      it 'should render a valid feed' do
        assert_feedvalidator response.body
      end
    end

    describe 'rendering as rss feed' do
      before(:each) do
        get :redirect, :from => ["#{contents(:article1).permalink}.html.rss"]
      end

      it 'should render rss20 partial' do
        response.should render_template('articles/_rss20_feed.rss.builder')
      end

      it 'should render a valid feed' do
        assert_feedvalidator response.body
      end
    end

    describe 'rendering comment feed with problematic characters' do
      before(:each) do
        @comment = contents(:article1).comments.first
        @comment.body = "&eacute;coute! 4 < 2, non?"
        @comment.save!
        get :redirect, :from => ["#{contents(:article1).permalink}.html.atom"]
      end

      it 'should result in a valid atom feed' do
        assigns(:article).should == contents(:article1)
        assert_feedvalidator response.body
      end
    end

  end
end
