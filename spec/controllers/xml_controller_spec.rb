require File.dirname(__FILE__) + '/../spec_helper'
require 'xml_controller'
require 'dns_mock'

describe XmlController do
  integrate_views

  def assert_select(*args, &block)
    @html_document ||= HTML::Document.new(@response.body, false, true)
    super(*args,&block)
  end

  before do
    Article.create!(:title => "News from the future!",
                    :body => "The future is cool!",
                    :keywords => "future",
                    :created_at => Time.now + 12.minutes)
  end

  def assert_moved_permanently_to(location)
    assert_response :moved_permanently
    assert_equal location, @response.headers["Location"]
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

    it "returns valid RSS feed for trackbacks feed type" do
      get :feed, :type => 'trackbacks'
      assert_response :success
      assert_xml @response.body
      assert_feedvalidator @response.body
      assert_rss20
    end

    it "redirects article feed to Article RSS feed" do
      get :feed, :type => 'article', :id => contents(:article1).id
      assert_moved_permanently_to contents(:article1).permalink_by_format(:rss)
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

  it "test_feed_rss20" do
    get :feed, :format => 'rss20', :type => 'feed'
    assert_moved_permanently_to 'http://test.host/articles.rss'
  end

  it "test_feed_rss20_comments" do
    get :feed, :format => 'rss20', :type => 'comments'
    assert_moved_permanently_to admin_comments_url(:format=>:rss)
  end

  it "test_feed_rss20_trackbacks" do
    get :feed, :format => 'rss20', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    assert_rss20
  end

  it "test_feed_rss20_article" do
    get :feed, :format => 'rss20', :type => 'article', :id => contents(:article1).id
    assert_moved_permanently_to contents(:article1).permalink_by_format(:rss)
  end

  it "test_feed_rss20_category" do
    get :feed, :format => 'rss20', :type => 'category', :id => 'personal'
    assert_moved_permanently_to(category_url('personal', :format => 'rss'))
  end

  it "test_feed_rss20_tag" do
    get :feed, :format => 'rss20', :type => 'tag', :id => 'foo'
    assert_moved_permanently_to(tag_url('foo', :format=>'rss'))
  end

  it "test_feed_atom10_feed" do
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :moved_permanently
    assert_moved_permanently_to "http://test.host/articles.atom"
  end

  it "test_feed_atom10_comments" do
    get :feed, :format => 'atom10', :type => 'comments'
    assert_response :moved_permanently
    assert_moved_permanently_to admin_comments_url(:format=>'atom')
  end

  it "test_feed_atom10_trackbacks" do
    get :feed, :format => 'atom10', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_equal(assigns(:items).sort { |a, b| b.created_at <=> a.created_at },
                 assigns(:items))

    assert_atom10

    assert_select 'title[type=html]'
    assert_select 'summary'
  end

  it "test_feed_atom10_article" do
    get :feed, :format => 'atom10', :type => 'article', :id => contents(:article1).id
    assert_moved_permanently_to contents(:article1).permalink_by_format('atom')
  end

  it "test_feed_atom10_category" do
    get :feed, :format => 'atom10', :type => 'category', :id => 'personal'
    assert_moved_permanently_to(category_url('personal', :format => 'atom'))
  end

  it "test_feed_atom10_tag" do
    get :feed, :format => 'atom10', :type => 'tag', :id => 'foo'
    assert_moved_permanently_to(tag_url('foo',:format => 'atom'))
  end

  it "test_articlerss" do
    get :articlerss, :id => contents(:article1).id
    assert_response :redirect
  end

  it "test_commentrss" do
    get :commentrss, :id => 1
    assert_response :redirect
  end

  it "test_trackbackrss" do
    get :trackbackrss, :id => 1
    assert_response :redirect
  end

  it "test_bad_format" do
    get :feed, :format => 'atom04', :type => 'feed'
    assert_response :missing
  end

  it "test_bad_type" do
    get :feed, :format => 'rss20', :type => 'foobar'
    assert_response :missing
  end

  it "test_rsd" do
    get :rsd, :id => 1
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end

  it "test_atom03" do
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :moved_permanently
    assert_moved_permanently_to 'http://test.host/articles.atom'
  end

  it "test_itunes" do
    get :itunes
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo
  end

  # TODO(laird): make this more robust
  it "test_sitemap" do
    get :feed, :format => 'googlesitemap', :type => 'sitemap'

    assert_response :success
    assert_xml @response.body
  end

  def assert_rss20
    assert_select 'rss:root[version=2.0] > channel item', :count => assigns(:items).size
  end

  def assert_atom10
    assert_select 'feed:root[xmlns="http://www.w3.org/2005/Atom"] > entry', :count => assigns(:items).size
  end

  def set_extended_on_rss(value)
    this_blog.show_extended_on_rss = value
  end
end
