# coding: utf-8
require 'spec_helper'

describe ArticlesController do
  render_views

  before(:each) do
    #TODO Need to reduce user, but allow to remove user fixture...
    Factory(:user,
            :login => 'henri',
            :password => 'whatever',
            :name => 'Henri',
            :email => 'henri@example.com',
            :settings => {:notify_watch_my_articles => false, :editor => 'simple'},
            :text_filter => Factory(:markdown),
            :profile => Factory(:profile_admin, :label => Profile::ADMIN),
            :notify_via_email => false,
            :notify_on_new_articles => false,
            :notify_on_comments => false,
            :state => 'active')
    Factory(:blog, :custom_tracking_field => '<script src="foo.js" type="text/javascript"></script>') 
  end


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
      Factory.create(:article)
      get 'index'
    end

    it 'should be render template index' do
      response.should render_template(:index)
    end

    it 'should show some articles' do
      assigns[:articles].should_not be_empty
    end

    it 'should have good link feed rss' do
      response.should have_selector('head>link[href="http://test.host/articles.rss"]')
    end

    it 'should have good link feed atom' do
      response.should have_selector('head>link[href="http://test.host/articles.atom"]')
    end

    it 'should have a canonical url' do
      response.should have_selector('head>link[href="http://test.host/"]')
    end
    
    it 'should have googd title' do 
      response.should have_selector('title', :content => "test blog | test subtitles")
    end
    
    it 'should have a custom tracking field' do      
      response.should have_selector('head>script[src="foo.js"]')
    end
  end


  describe '#search action' do
    before :each do
      Factory(:article,
              :body => "in markdown format\n\n * we\n * use\n [ok](http://blog.ok.com) to define a link",
              :text_filter => Factory(:markdown))
      Factory(:article, :body => "xyz")
    end

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
        response.should have_selector('head>link[href="http://test.host/search/a.rss"]')
      end

      it 'should have good feed atom link' do
        response.should have_selector('head>link[href="http://test.host/search/a.atom"]')
      end

      it 'should have a canonical url' do
        response.should have_selector('head>link[href="http://test.host/search/a"]')
      end
      
      it 'should have a good title' do
        response.should have_selector('title', :content => "Results for a | test blog")
      end

      it 'should have content markdown interpret and without html tag' do
        response.should have_selector('div') do |div|
          div.should contain(/in markdown format\n\n\nwe\nuse\nok to define a link\n\n...\n/)
        end
      end

      it 'should have a custom tracking field' do      
        response.should have_selector('head>script[src="foo.js"]')
      end
    end

    it 'should render feed rss by search' do
      get 'search', :q => 'a', :format => 'rss'
      response.should be_success
      response.should render_template('index_rss_feed')
      @layouts.keys.compact.should be_empty
      response.should_not have_selector('head>script[src="foo.js"]')    
    end

    it 'should render feed atom by search' do
      get 'search', :q => 'a', :format => 'atom'
      response.should be_success
      response.should render_template('index_atom_feed')
      @layouts.keys.compact.should be_empty
      response.should_not have_selector('head>script[src="foo.js"]')      
    end

    it 'search with empty result' do
      get 'search', :q => 'abcdefghijklmnopqrstuvwxyz'
      response.should render_template('articles/error')
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
        response.should render_template(:layout => nil)
      end

      it 'should render template live_search' do
        response.should render_template('live_search')
      end

      it 'should not have h3 tag' do
        response.should have_selector("h3")
      end

      it "should assign @search the search string" do
        assigns[:search].should be_equal(controller.params[:q])
      end

    end
  end


  it 'archives' do
    3.times { Factory(:article) }
    get 'archives'
    response.should render_template(:archives)
    assigns[:articles].should_not be_nil
    assigns[:articles].should_not be_empty

    response.should have_selector('head>link[href="http://test.host/archives"]')
    response.should have_selector('title', :content => "Archives for test blog")
    response.should have_selector('head>script[src="foo.js"]')
  end

  describe 'index for a month' do

    before :each do
      Factory(:article, :published_at => Time.utc(2004, 4, 23))
      get 'index', :year => 2004, :month => 4
    end

    it 'should render template index' do
      response.should render_template(:index)
    end

    it 'should contain some articles' do
      assigns[:articles].should_not be_nil
      assigns[:articles].should_not be_empty
    end

    it 'should have a canonical url' do
      response.should have_selector('head>link[href="http://test.host/2004/4/"]')
    end
    
    it 'should have a good title' do
      response.should have_selector('title', :content => "Archives for test blog")
    end
    
    it 'should have a custom tracking field' do      
      response.should have_selector('head>script[src="foo.js"]')
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
    Factory(:blog)
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
  before(:each) do
    Factory(:blog)
    @article1 = Factory.create(:article,
                               :created_at => Time.now - 1.day)
    Factory.create(:trackback, :article => @article1, :published_at => Time.now - 1.day,
                   :published => true)
    @article2 = Factory.create(:article,
                               :created_at => '2004-04-01 12:00:00',
                               :published_at => '2004-04-01 12:00:00',
                               :updated_at => '2004-04-01 12:00:00')

  end

  specify "/articles.atom => an atom feed" do
    get 'index', :format => 'atom'
    response.should be_success
    response.should render_template("index_atom_feed")
    assigns(:articles).should == [@article1, @article2]
    @layouts.keys.compact.should be_empty
  end

  specify "/articles.rss => an RSS 2.0 feed" do
    get 'index', :format => 'rss'
    response.should be_success
    response.should render_template("index_rss_feed")
    assigns(:articles).should == [@article1, @article2]
    @layouts.keys.compact.should be_empty
  end

  specify "atom feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'atom'
    response.should render_template("index_atom_feed")
    assigns(:articles).should == [@article2]
    @layouts.keys.compact.should be_empty
  end

  specify "RSS feed for archive should be valid" do
    get 'index', :year => 2004, :month => 4, :format => 'rss'
    response.should render_template("index_rss_feed")
    assigns(:articles).should == [@article2]
    @layouts.keys.compact.should be_empty
  end
end

describe ArticlesController, "the index" do
  before(:each) do
    Factory(:blog) 
    Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
  end

  it "should ignore the HTTP Accept: header" do
    request.env["HTTP_ACCEPT"] = "application/atom+xml"
    get "index"
    response.should render_template("index")
  end
end

describe ArticlesController, "previewing" do
  render_views
  before(:each) { @blog = Factory(:blog) }

  describe 'with non logged user' do
    before :each do
      @request.session = {}
      get :preview, :id => Factory(:article).id
    end

    it 'should redirect to login' do
      response.should redirect_to(:controller => "accounts", :action => "login")
    end
  end

  describe 'with logged user' do
    before :each do
      #TODO Delete after removing fixtures
      Profile.delete_all
      henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      @request.session = { :user => henri.id }
      @article = Factory(:article)
    end

    with_each_theme do |theme, view_path|
      it "should render template #{view_path}/articles/read" do
        @blog.theme = theme if theme
        get :preview, :id => @article.id
        response.should render_template('articles/read')
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

  describe "with explicit redirects" do
    it 'should redirect from known URL' do
      #TODO Need to reduce user, but allow to remove user fixture...
      Factory(:user,
              :login => 'henri',
              :password => 'whatever',
              :name => 'Henri',
              :email => 'henri@example.com',
              :settings => {:notify_watch_my_articles => false, :editor => 'simple'},
              :text_filter => Factory(:markdown),
              :profile => Factory(:profile_admin, :label => Profile::ADMIN),
              :notify_via_email => false,
              :notify_on_new_articles => false,
              :notify_on_comments => false,
              :state => 'active')
      Factory(:blog)
      Factory(:redirect)
      get :redirect, :from => "foo/bar"
      assert_response 301
      response.should redirect_to("http://test.host/someplace/else")
    end

    it 'should not redirect from unknown URL' do
      #TODO Need to reduce user, but allow to remove user fixture...
      Factory(:user,
              :login => 'henri',
              :password => 'whatever',
              :name => 'Henri',
              :email => 'henri@example.com',
              :settings => {:notify_watch_my_articles => false, :editor => 'simple'},
              :text_filter => Factory(:markdown),
              :profile => Factory(:profile_admin, :label => Profile::ADMIN),
              :notify_via_email => false,
              :notify_on_new_articles => false,
              :notify_on_comments => false,
              :state => 'active')
      Factory(:blog)
      Factory(:redirect)
      get :redirect, :from => "something/that/isnt/there"
      assert_response 404
    end

    # FIXME: Due to the changes in Rails 3 (no relative_url_root), this
    # does not work anymore when the accessed URL does not match the blog's
    # base_url at least partly. Do we still want to allow acces to the blog
    # through non-standard URLs? What was the original purpose of these
    # redirects?
    describe 'and non-empty relative_url_root' do
      before do
        b = Factory(:blog, :base_url => "http://test.host/blog")
        #TODO Need to reduce user, but allow to remove user fixture...
        Factory(:user,
                :login => 'henri',
                :password => 'whatever',
                :name => 'Henri',
                :email => 'henri@example.com',
                :settings => {:notify_watch_my_articles => false, :editor => 'simple'},
                :text_filter => Factory(:markdown),
                :profile => Factory(:profile_admin, :label => Profile::ADMIN),
                :notify_via_email => false,
                :notify_on_new_articles => false,
                :notify_on_comments => false,
                :state => 'active')

        # XXX: The following has no effect anymore.
        # request.env["SCRIPT_NAME"] = "/blog"
      end

      it 'should redirect' do
        Factory(:redirect, :from_path => 'foo/bar', :to_path => '/someplace/else')
        get :redirect, :from => "foo/bar"
        assert_response 301
        response.should redirect_to("http://test.host/blog/someplace/else")
      end

      it 'should redirect if to_path includes relative_url_root' do
        Factory(:redirect, :from_path => 'bar/foo', :to_path => '/blog/someplace/else')
        get :redirect, :from => "bar/foo"
        assert_response 301
        response.should redirect_to("http://test.host/blog/someplace/else")
      end

      it "should ignore the blog base_url if the to_path is a full uri" do
        Factory(:redirect, :from_path => 'foo', :to_path => 'http://some.where/else')
        get :redirect, :from => "foo"
        assert_response 301
        response.should redirect_to("http://some.where/else")
      end
    end
  end

  it 'should get good article with utf8 slug' do
    Factory(:blog)
    utf8article = Factory.create(:utf8article, :permalink => 'ルビー',
                                 :published_at => Time.utc(2004, 6, 2))
    get :redirect, :from => '2004/06/02/ルビー'
    assigns(:article).should == utf8article
  end

  # NOTE: This is needed because Rails over-unescapes glob parameters.
  it 'should get good article with pre-escaped utf8 slug using unescaped slug' do
    Factory(:blog)
    utf8article = Factory.create(:utf8article, :permalink => '%E3%83%AB%E3%83%93%E3%83%BC',
                                 :published_at => Time.utc(2004, 6, 2))
    get :redirect, :from => '2004/06/02/ルビー'
    assigns(:article).should == utf8article
  end

  describe 'accessing old-style URL with "articles" as the first part' do
    it 'should redirect to article' do
      Factory(:blog)
      article = Factory(:article, :permalink => 'second-blog-article',
                        :published_at => '2004-04-01 02:00:00',
                        :updated_at => '2004-04-01 02:00:00',
                        :created_at => '2004-04-01 02:00:00')
      get :redirect, :from => "articles/2004/04/01/second-blog-article"
      assert_response 301
      response.should redirect_to("http://myblog.net/2004/04/01/second-blog-article")
    end

    it 'should redirect to article with url_root' do
      b = Factory(:blog, :base_url => "http://test.host/blog")
      article = Factory(:article, :permalink => 'second-blog-article',
                        :published_at => '2004-04-01 02:00:00',
                        :updated_at => '2004-04-01 02:00:00',
                        :created_at => '2004-04-01 02:00:00')
      get :redirect, :from => "articles/2004/04/01/second-blog-article"
      assert_response 301
      response.should redirect_to("http://test.host/blog/2004/04/01/second-blog-article")
    end

    it 'should redirect to article with articles in url_root' do
      b = Factory(:blog, :base_url => "http://test.host/aaa/articles/bbb")
      article = Factory(:article, :permalink => 'second-blog-article',
                        :published_at => '2004-04-01 02:00:00',
                        :updated_at => '2004-04-01 02:00:00',
                        :created_at => '2004-04-01 02:00:00')
      get :redirect, :from => "articles/2004/04/01/second-blog-article"
      assert_response 301
      response.should redirect_to("http://test.host/aaa/articles/bbb/2004/04/01/second-blog-article")
    end
  end

  describe 'with permalink_format like %title%.html' do

    before(:each) do
      b = Factory(:blog, :permalink_format => '/%title%.html')

      @article = Factory(:article, :permalink => 'second-blog-article',
                         :published_at => '2004-04-01 02:00:00',
                         :updated_at => '2004-04-01 02:00:00',
                         :created_at => '2004-04-01 02:00:00')
    end

    describe "accessing various non-matching URLs" do
      it "should not find '.htmlsecond-blog-article'" do
        get :redirect, :from => ".html#{@article.permalink}"
        assert_response 404
      end

      it "should not find 'second-blog-article.html.html'" do
        get :redirect, :from => "#{@article.permalink}.html.html"
        assert_response 404
      end

      it "should not find 'second-blog-article.html/foo'" do
        get :redirect, :from => "#{@article.permalink}.html/foo"
        assert_response 404
      end
    end

    describe "accessing legacy URLs" do
      it 'should redirect from default URL format' do
        get :redirect, :from => "2004/04/01/second-blog-article"
        assert_response 301
        response.should redirect_to("http://myblog.net/second-blog-article.html")
      end

      it 'should redirect from old-style URL format with "articles" part' do
        get :redirect, :from => "articles/2004/04/01/second-blog-article"
        assert_response 301
        response.should redirect_to("http://myblog.net/second-blog-article.html")
      end
    end

    describe 'accessing an article' do

      before(:each) do
        get :redirect, :from => "#{@article.permalink}.html"
      end

      it 'should render template read to article' do
        response.should render_template('articles/read')
      end

      it 'should assign article1 to @article' do
        assigns(:article).should == @article
      end

      describe "the resulting page" do
        render_views

        it 'should have good rss feed link' do
          response.should have_selector("head>link[href=\"http://myblog.net/#{@article.permalink}.html.rss\"]")
        end

        it 'should have good atom feed link' do
          response.should have_selector("head>link[href=\"http://myblog.net/#{@article.permalink}.html.atom\"]")
        end

        it 'should have a canonical url' do
          response.should have_selector("head>link[href='http://myblog.net/#{@article.permalink}.html']")
        end

        it 'should have a good title' do
          response.should have_selector('title', :content => "A big article | test blog")
        end
      end

    end

    describe 'rendering as atom feed' do
      before(:each) do
        @trackback1 = Factory.create(:trackback, :article => @article, :published_at => Time.now - 1.day,
                                     :published => true)
        get :redirect, :from => "#{@article.permalink}.html.atom"
      end

      it 'should render feedback atom feed' do
        assigns(:feedback).should == [@trackback1]
        response.should render_template('feedback_atom_feed')
        @layouts.keys.compact.should be_empty
      end
    end

    describe 'rendering as rss feed' do
      before(:each) do
        @trackback1 = Factory.create(:trackback, :article => @article, :published_at => Time.now - 1.day,
                                     :published => true)
        get :redirect, :from => "#{@article.permalink}.html.rss"
      end

      it 'should render rss20 partial' do
        assigns(:feedback).should == [@trackback1]
        response.should render_template('feedback_rss_feed')
        @layouts.keys.compact.should be_empty
      end
    end
  end

  describe "with a format containing a fixed component" do
    before(:each) do
      b = Factory(:blog, :permalink_format => '/foo/%title%')

      @article = Factory(:article)
    end

    it "should find the article if the url matches all components" do
      get :redirect, :from => "foo/#{@article.permalink}"
      response.should be_success
    end

    it "should not find the article if the url does not match the fixed component" do
      get :redirect, :from => "bar/#{@article.permalink}"
      assert_response 404
    end
  end

  describe "with a custom format with several fixed parts and several variables" do
    before(:each) do
      b = Factory(:blog, :permalink_format => '/foo/bar/%year%/%month%/%title%')

      @article = Factory(:article)
    end

    it "should find the article if the url matches all components" do
      get :redirect, :from => "foo/bar/#{@article.year_url}/#{@article.month_url}/#{@article.permalink}"
      response.should be_success
    end

    # FIXME: Documents current behavior; Blog URL format is only meant for one article shown
    it "should not find the article if the url only matches some components" do
      get :redirect, :from => "foo/bar/#{@article.year_url}/#{@article.month_url}"
      assert_response 404
    end

    # TODO: Think about allowing this, and changing find_by_params_hash to match.
    if false
      it "should find the article if the url matches all fixed parts and no variable components" do
        get :redirect, :from => "foo/bar"
        response.should be_success
      end

      it "should not find the article if the url does not match all fixed component" do
        get :redirect, :from => "foo"
        assert_response 404
      end
    end
  end
end

describe ArticlesController, "password protected" do
  render_views

  before do
    b = Factory(:blog, :permalink_format => '/%title%.html')
    @article = Factory(:article, :password => 'password')
  end

  it 'article alone should be password protected' do
    get :redirect, :from => "#{@article.permalink}.html"
    response.should have_selector('input[id="article_password"]', :count => 1)
  end

  describe "#check_password" do
    it "shows article when given correct password" do
      xhr :get, :check_password, :article => {:id => @article.id, :password => @article.password}
      response.should_not have_selector('input[id="article_password"]')
    end

    it "shows password form when given incorrect password" do
      xhr :get, :check_password, :article => {:id => @article.id, :password => "wrong password"}
      response.should have_selector('input[id="article_password"]')
    end
  end
end

describe ArticlesController, "assigned keywords" do
  before do
    @blog = Factory(:blog)
    #TODO Need to reduce user, but allow to remove user fixture...
    Factory(:user,
            :login => 'henri',
            :password => 'whatever',
            :name => 'Henri',
            :email => 'henri@example.com',
            :settings => {:notify_watch_my_articles => false, :editor => 'simple'},
            :text_filter => Factory(:markdown),
            :profile => Factory(:profile_admin, :label => Profile::ADMIN),
            :notify_via_email => false,
            :notify_on_new_articles => false,
            :notify_on_comments => false,
            :state => 'active')

  end

  it 'article with categories should have meta keywords' do
    @blog.permalink_format = '/%title%.html'
    @blog.save
    category = Factory(:category)
    article = Factory(:article, :categories => [category])
    get :redirect, :from => "#{article.permalink}.html"
    assigns(:keywords).should == category.name
  end

  it 'article with neither categories nor tags should not have meta keywords' do
    @blog.permalink_format = '/%title%.html'
    @blog.save
    article = Factory(:article)
    get :redirect, :from => "#{article.permalink}.html"
    assigns(:keywords).should == ""
  end

  it 'index without option and no blog keywords should not have meta keywords' do
    get 'index'
    assigns(:keywords).should == ""
  end

  it 'index without option but with blog keywords should have meta keywords' do
    @blog.meta_keywords = "typo, is, amazing"
    @blog.save
    get 'index'
    assigns(:keywords).should == "typo, is, amazing"
  end
end
