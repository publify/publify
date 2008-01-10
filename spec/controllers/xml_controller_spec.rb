require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../test/test_helper'
require 'xml_controller'
require 'dns_mock'

# This test now has optional support for validating the generated RSS feeds.
# Since Ruby doesn't have a RSS/Atom validator, I'm using the Python source
# for http://feedvalidator.org and calling it via 'system'.
#
# To install the validator, download the source from
# http://sourceforge.net/cvs/?group_id=99943
# Then copy src/feedvalidator and src/rdflib into a Python lib directory.
# Finally, copy src/demo.py into your path as 'feedvalidator', make it executable,
# and change the first line to something like '#!/usr/bin/python'.

if($validator_installed == nil)
  $validator_installed = false
  begin
    IO.popen("feedvalidator 2> /dev/null","r") do |pipe|
      if (pipe.read =~ %r{Validating http://www.intertwingly.net/blog/index.})
        puts "Using locally installed Python feed validator"
        $validator_installed = true
      end
    end
  rescue
    nil
  end
end

# Re-raise errors caught by the controller.
class XmlController; def rescue_action(e) raise e end; end

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

  def assert_feedvalidator(rss, todo=nil)
    return unless $validator_installed

    begin
      file = Tempfile.new('typo-feed-test')
      filename = file.path
      file.write(rss)
      file.close

      messages = ''

      IO.popen("feedvalidator file://#{filename}") do |pipe|
        messages = pipe.read
      end

      okay, messages = parse_validator_messages(messages)

      if todo && ! ENV['RUN_TODO_TESTS']
        assert !okay, messages + "\nTest unexpectedly passed!\nFeed text:\n"+rss
      else
        assert okay, messages + "\nFeed text:\n"+rss
      end
    end
  end

  def parse_validator_messages(message)
    messages=message.split(/\n/).reject do |m|
      m =~ /Feeds should not be served with the "text\/plain" media type/ ||
      m =~ /Self reference doesn't match document location/
    end

    if(messages.size > 1)
      [false, messages.join("\n")]
    else
      [true, ""]
    end
  end

  def assert_moved_permanently_to(location)
    assert_response :moved_permanently
    assert_equal location, @response.headers["Location"]
  end

  def test_feed_rss20
    get :feed, :format => 'rss20', :type => 'feed'
    assert_moved_permanently_to formatted_articles_url(:rss)
  end

  def test_feed_rss20_comments
    get :feed, :format => 'rss20', :type => 'comments'
    assert_response :moved_permanently
    assert_moved_permanently_to formatted_admin_comments_url(:rss)
  end

  def test_feed_rss20_trackbacks
    get :feed, :format => 'rss20', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    assert_rss20
  end

  def test_feed_rss20_article
    get :feed, :format => 'rss20', :type => 'article', :id => contents(:article1).id
    assert_moved_permanently_to formatted_article_url(contents(:article1), :rss)
  end

  def test_feed_rss20_category
    get :feed, :format => 'rss20', :type => 'category', :id => 'personal'
    assert_moved_permanently_to(formatted_category_url('personal', 'rss'))
  end

  def test_feed_rss20_tag
    get :feed, :format => 'rss20', :type => 'tag', :id => 'foo'
    assert_moved_permanently_to(formatted_tag_url('foo', 'rss'))
  end

  def test_feed_atom10_feed
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :moved_permanently
    assert_moved_permanently_to formatted_articles_url('atom')
  end

  def test_feed_atom10_comments
    get :feed, :format => 'atom10', :type => 'comments'
    assert_response :moved_permanently
    assert_moved_permanently_to formatted_admin_comments_url('atom')
  end

  def test_feed_atom10_trackbacks
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

  def test_feed_atom10_article
    get :feed, :format => 'atom10', :type => 'article', :id => contents(:article1).id
    assert_moved_permanently_to formatted_article_url(contents(:article1), 'atom')
  end

  def test_feed_atom10_category
    get :feed, :format => 'atom10', :type => 'category', :id => 'personal'
    assert_moved_permanently_to(formatted_category_url('personal', 'atom'))
  end

  def test_feed_atom10_tag
    get :feed, :format => 'atom10', :type => 'tag', :id => 'foo'
    assert_moved_permanently_to(formatted_tag_url('foo', 'atom'))
  end

  def test_articlerss
    get :articlerss, :id => contents(:article1).id
    assert_response :redirect
  end

  def test_commentrss
    get :commentrss, :id => 1
    assert_response :redirect
  end

  def test_trackbackrss
    get :trackbackrss, :id => 1
    assert_response :redirect
  end

  def test_bad_format
    get :feed, :format => 'atom04', :type => 'feed'
    assert_response :missing
  end

  def test_bad_type
    get :feed, :format => 'rss20', :type => 'foobar'
    assert_response :missing
  end

  def test_rsd
    get :rsd, :id => 1
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end

  def test_atom03
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :moved_permanently
    assert_moved_permanently_to formatted_articles_url('atom')
  end

  def test_itunes
    get :itunes
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body, :todo
  end

  # TODO(laird): make this more robust
  def test_sitemap
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
