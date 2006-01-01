require File.dirname(__FILE__) + '/../test_helper'
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
      if (pipe.read =~ %r{Validating http://www.intertwingly.net/blog/index.rss2})
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

class XmlControllerTest < Test::Unit::TestCase
  fixtures :contents, :categories, :articles_categories, :tags, 
    :articles_tags, :users, :settings, :resources

  def setup
    @controller = XmlController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end
  
  def assert_feedvalidator(rss)
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

      assert okay, messages + "\nFeed text:\n"+rss
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
  
  def test_feed_rss20
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    
    assert_tag :tag => 'channel', :children => {:count => 4, :only => {:tag => 'item' }}
  end
  
  def test_feed_rss20_comments
    get :feed, :format => 'rss20', :type => 'comments'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'channel', :children => {:count => 3, :only => {:tag => 'item' }}
  end

  def test_feed_rss20_trackbacks
    get :feed, :format => 'rss20', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'channel', :children => {:count => 2, :only => {:tag => 'item' }}
  end

  def test_feed_rss20_article
    get :feed, :format => 'rss20', :type => 'article', :id => 1
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    
    assert_tag :tag => 'channel', :children => {:count => 2, :only => {:tag => 'item' }}
  end

  def test_feed_rss20_category
    get :feed, :format => 'rss20', :type => 'category', :id => 'personal'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'channel', :children => {:count => 3, :only => {:tag => 'item' }}
  end
  
  def test_feed_rss20_tag
    get :feed, :format => 'rss20', :type => 'tag', :id => 'foo'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'channel', :children => {:count => 2, :only => {:tag => 'item' }}
  end

  def test_feed_atom03_feed
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    
    assert_tag :tag => 'feed', :children => {:count => 4, :only => {:tag => 'entry' }}
  end

  def test_feed_atom03_comments
    get :feed, :format => 'atom03', :type => 'comments'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    
    assert_tag :tag => 'feed', :children => {:count => 3, :only => {:tag => 'entry' }}
  end

  def test_feed_atom03_trackbacks
    get :feed, :format => 'atom03', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
    
    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end

  def test_feed_atom03_article
    get :feed, :format => 'atom03', :type => 'article', :id => 1
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end
  
  def test_feed_atom03_category
    get :feed, :format => 'atom03', :type => 'category', :id => 'personal'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 3, :only => {:tag => 'entry' }}
  end

  def test_feed_atom03_tag
    get :feed, :format => 'atom03', :type => 'tag', :id => 'foo'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_feed
    get :feed, :format => 'atom10', :type => 'feed'
    
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 4, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_comments
    get :feed, :format => 'atom10', :type => 'comments'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 3, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_trackbacks
    get :feed, :format => 'atom10', :type => 'trackbacks'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_article
    get :feed, :format => 'atom10', :type => 'article', :id => 1
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_category
    get :feed, :format => 'atom10', :type => 'category', :id => 'personal'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 3, :only => {:tag => 'entry' }}
  end

  def test_feed_atom10_tag
    get :feed, :format => 'atom10', :type => 'tag', :id => 'foo'
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body

    assert_tag :tag => 'feed', :children => {:count => 2, :only => {:tag => 'entry' }}
  end

  def test_articlerss
    get :articlerss, :id => 1 
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

  def test_pubdate_conformance
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    xml = REXML::Document.new(@response.body)
    assert_equal contents(:article2).created_at.rfc822, REXML::XPath.match(xml, '/rss/channel/item/pubDate').first.text
  end
  
  def test_rsd
    get :rsd, :id => 1 
    assert_response :success
    assert_nothing_raised do
      assert REXML::Document.new(@response.body)
    end
  end 
  
  def test_extended_rss20
    set_extended_on_rss true
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
    assert_match /extended content/, @response.body

    set_extended_on_rss false
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success  	
    assert_no_match /extended content/, @response.body
  end

  def test_extended_atom03
    set_extended_on_rss true
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :success
    assert_match /extended content/, @response.body

    set_extended_on_rss false
    get :feed, :format => 'atom03', :type => 'feed'
    assert_response :success  	
    assert_no_match /extended content/, @response.body
  end

  def test_extended_atom10
    set_extended_on_rss true
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success
    assert_match /extended content/, @response.body

    set_extended_on_rss false
    get :feed, :format => 'atom10', :type => 'feed'
    assert_response :success  	
    assert_no_match /extended content/, @response.body
  end
  
  def test_enclosure_rss20
    get :feed, :format => 'rss20', :type => 'feed'
    assert_response :success
  
    # There's an enclosure in there somewhere
    assert_xpath('/rss/channel/item/enclosure')
    
    # There's an enclosure attached to the node with the title "Article 1!"
    assert_xpath('/rss/channel/item[title="Article 1!"]/enclosure')    
    assert_xpath('/rss/channel/item[title="Article 2!"]/enclosure')
    
    # Article 3 exists, but has no enclosure
    assert_xpath('/rss/channel/item[title="Article 3!"]')
    assert_not_xpath('/rss/channel/item[title="Article 3!"]/enclosure')
  end
  
  def test_itunes
    get :itunes
    assert_response :success
    assert_xml @response.body
    assert_feedvalidator @response.body
  end

  def get_xpath(xpath)
    rexml = REXML::Document.new(@response.body)
    assert rexml

    rexml.get_elements(xpath)
  end
  
  def assert_xpath(xpath)
    assert !(get_xpath(xpath).empty?)
  end
  
  def assert_not_xpath(xpath)
    assert get_xpath(xpath).empty?
  end

  def set_extended_on_rss(value)
    setting = Setting.find_by_name('show_extended_on_rss') || Setting.new(:name => 'show_extended_on_rss')
    setting.value = value
    setting.save
    config.reload
    assert config["show_extended_on_rss"] == value
  end
end
