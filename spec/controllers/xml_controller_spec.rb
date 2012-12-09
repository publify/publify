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

  describe "#feed" do
    describe "without format parameter" do
      it "redirects main feed to articles RSS feed" do
        get :feed, :type => 'feed'
        assert_moved_permanently_to 'http://test.host/articles.rss'
      end

      it "redirects comments feed to Comments RSS feed" do
        get :feed, :type => 'comments'
        assert_moved_permanently_to admin_comments_url(:format=>:rss)
      end

      it "redirects trackbacks feed to TrackbacksController RSS feed" do
        get :feed, :type => 'trackbacks'
        assert_moved_permanently_to trackbacks_url(:format => :rss)
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

      it "redirects trackbacks feed to TrackbacksController RSS feed" do
        get :feed, :format => 'rss20', :type => 'trackbacks'
        assert_moved_permanently_to trackbacks_url(:format => :rss)
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

      it "redirects trackbacks feed to TrackbacksController Atom feed" do
        get :feed, :format => 'atom10', :type => 'trackbacks'
        assert_moved_permanently_to trackbacks_url(:format => :atom)
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
          assert_moved_permanently_to @article.feed_url('rss')
        end
      end

      describe "with format rss20" do
        it "redirects the article feed to the article RSS feed" do
          get :feed, :format => 'rss20', :type => 'article', :id => @article.id
          assert_moved_permanently_to @article.feed_url('rss')
        end
      end

      describe "with format atom10" do
        it "redirects the article feed to the article Atom feed" do
          get :feed, :format => 'atom10', :type => 'article', :id => @article.id
          assert_moved_permanently_to @article.feed_url('atom')
        end
      end
    end

    it "responds :missing when given a bad format" do
      get :feed, :format => 'atom04', :type => 'feed'
      assert_response :missing
    end

    it "responds :missing when given a bad type" do
      get :feed, :format => 'rss20', :type => 'foobar'
      assert_response :missing
    end
  end

  describe "#articlerss" do
    before do
      @article = stub_model(Article, :published_at => Time.now, :permalink => "foo")
      Article.stub(:find) { @article }
    end

    it "redirects permanently to the article RSS feed" do
      get :articlerss, :id => @article.id
      assert_moved_permanently_to @article.feed_url('rss')
    end
  end

  describe "#commentrss" do
    it "redirects permanently to the comment RSS feed" do
      get :commentrss, :id => 1
      assert_moved_permanently_to admin_comments_url(:format=>'rss')
    end
  end

  describe "#trackbackrss" do
    it "redirects permanently to the trackback RSS feed" do
      get :trackbackrss, :id => 1
      assert_moved_permanently_to trackbacks_url(:format=>'rss')
    end
  end

  # TODO: make this more robust
  describe "#rsd" do
    before do
      get :rsd
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
      FactoryGirl.create(:category)
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
