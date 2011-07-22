require 'spec_helper'

describe XmlController do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net")
    Blog.stub(:default) { blog }
    Trigger.stub(:fire) { }
  end

  def assert_moved_permanently_to(location)
    assert_response :moved_permanently
    assert_redirected_to location
  end

  describe "rendering" do
    render_views

    it "returns valid RSS feed for trackbacks feed type" do
      Feedback.delete_all

      article = Factory.create(:article, :created_at => Time.now - 1.day,
                               :allow_pings => true, :published => true)
      Factory.create(:trackback, :article => article,
                     :published_at => Time.now - 1.day,
                     :published => true)

      get :feed, :type => 'trackbacks'
      assert_response :success
      assert_xml @response.body
      assert_feedvalidator @response.body
      assert_rss20 @response.body, 1
    end

    it "returns valid RSS feed for trackbacks feed type with format rss20" do
      Feedback.delete_all

      article = Factory.create(:article, :created_at => Time.now - 1.day,
                               :allow_pings => true, :published => true)
      Factory.create(:trackback, :article => article,
                     :published_at => Time.now - 1.day,
                     :published => true)

      get :feed, :format => 'rss20', :type => 'trackbacks'
      assert_response :success
      assert_xml @response.body
      assert_feedvalidator @response.body
      assert_rss20 @response.body, 1
    end

    it "returns valid Atom feed for trackbacks feed type with format atom10" do
      Feedback.delete_all
      article = Factory.create(:article, :created_at => Time.now - 1.day,
                               :allow_pings => true, :published => true)
      Factory.create(:trackback, :article => article, :published_at => Time.now - 1.day,
                     :published => true)

      get :feed, :format => 'atom10', :type => 'trackbacks'
      assert_response :success
      assert_xml @response.body
      assert_feedvalidator @response.body
      assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                   assigns(:items))

      assert_atom10 @response.body, 1

      assert_select 'title[type=html]'
      assert_select 'summary'
    end

  end

  describe "without format parameter" do
    it "redirects main feed to articles RSS feed" do
      get :feed, :type => 'feed'
      assert_moved_permanently_to 'http://test.host/articles.rss'
    end

    it "redirects comments feed to Comments RSS feed" do
      get :feed, :type => 'comments'
      assert_moved_permanently_to admin_comments_url(:format=>:rss)
    end

    it "redirects category feed to Category RSS feed" do
      get :feed, :type => 'category', :id => 'personal'
      assert_moved_permanently_to(category_url('personal', :format => 'rss'))
    end

    it "redirects tag feed to Tag RSS feed" do
      get :feed, :type => 'tag', :id => 'foo'
      assert_moved_permanently_to(tag_url('foo', :format=>'rss'))
    end
  end

  describe "with format rss20" do
    it "redirects main feed to articles RSS feed" do
      get :feed, :format => 'rss20', :type => 'feed'
      assert_moved_permanently_to 'http://test.host/articles.rss'
    end

    it "redirects comments feed to comments RSS feed" do
      get :feed, :format => 'rss20', :type => 'comments'
      assert_moved_permanently_to admin_comments_url(:format=>:rss)
    end

    it "redirects category feed to category RSS feed" do
      get :feed, :format => 'rss20', :type => 'category', :id => 'personal'
      assert_moved_permanently_to(category_url('personal', :format => 'rss'))
    end

    it "redirects tag feed to tag RSS feed" do
      get :feed, :format => 'rss20', :type => 'tag', :id => 'foo'
      assert_moved_permanently_to(tag_url('foo', :format=>'rss'))
    end
  end

  describe "with format atom10" do
    it "redirects main feed to articles Atom feed" do
      get :feed, :format => 'atom10', :type => 'feed'
      assert_moved_permanently_to "http://test.host/articles.atom"
    end

    it "redirects comments feed to comments Atom feed" do
      get :feed, :format => 'atom10', :type => 'comments'
      assert_moved_permanently_to admin_comments_url(:format=>'atom')
    end

    it "redirects category feed to category Atom feed" do
      get :feed, :format => 'atom10', :type => 'category', :id => 'personal'
      assert_moved_permanently_to category_url('personal', :format => 'atom')
    end

    it "redirects tag feed to tag Atom feed" do
      get :feed, :format => 'atom10', :type => 'tag', :id => 'foo'
      assert_moved_permanently_to tag_url('foo',:format => 'atom')
    end
  end

  describe "with format atom03" do
    it "redirects main feed to articles Atom feed" do
      get :feed, :format => 'atom03', :type => 'feed'
      assert_moved_permanently_to 'http://test.host/articles.atom'
    end
  end

  describe "for an article" do
    before do
      @article = stub_model(Article, :published_at => Time.now, :permalink => "foo")
      Article.stub(:find) { @article }
    end

    describe "without format parameter" do
      it "redirects article feed to Article RSS feed" do
        get :feed, :type => 'article', :id => @article.id
        assert_moved_permanently_to @article.permalink_by_format(:rss)
      end
    end

    describe "with format rss20" do
      it "redirects the article feed to the article RSS feed" do
        get :feed, :format => 'rss20', :type => 'article', :id => @article.id
        assert_moved_permanently_to @article.permalink_by_format(:rss)
      end
    end

    describe "with format atom10" do
      it "redirects the article feed to the article Atom feed" do
        get :feed, :format => 'atom10', :type => 'article', :id => @article.id
        assert_moved_permanently_to @article.permalink_by_format('atom')
      end
    end
  end

  it "redirects #articlerss" do
    get :articlerss, :id => 123
    assert_response :redirect
  end

  it "redirects #commentrss" do
    get :commentrss, :id => 1
    assert_response :redirect
  end

  it "redirects #trackbackrss" do
    get :trackbackrss, :id => 1
    assert_response :redirect
  end

  it "responds :missing when given a bad format" do
    get :feed, :format => 'atom04', :type => 'feed'
    assert_response :missing
  end

  it "responds :missing when given a bad type" do
    get :feed, :format => 'rss20', :type => 'foobar'
    assert_response :missing
  end

  # TODO: make this more robust
  describe "#rsd" do
    before do
      get :rsd, :id => 1
    end

    it "is succesful" do
      assert_response :success
    end

    it "returns a valid XML response" do
      assert_xml @response.body
    end
  end

  # TODO: make this more robust
  describe "#feed with googlesitemap format" do
    before do
      Factory(:category)
      get :feed, :format => 'googlesitemap', :type => 'sitemap'
    end

    it "is succesful" do
      assert_response :success
    end

    it "returns a valid XML response" do
      assert_xml @response.body
    end
  end
end
