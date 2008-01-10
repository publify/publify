require File.dirname(__FILE__) + '/../test_helper'

require 'http_mock'
require 'xmlrpc_mock'

class PingTest < Test::Unit::TestCase
  def setup
    @pingback_header = nil
    @body = ''
  end

  def teardown
    Net::HTTP.next_response = nil
  end

  def test_send_pingback_found_in_pingback_header

    # We've linked to http://anotherblog.org/a-post from
    # http://myblog.net/referring-post and discovered a pingback
    # listener at http://anotherblog.org/xml-rpc
    # Set up the mocking


    @pingback_header = "http://anotherblog.org/xml-rpc"
    assert_pingback_sent
  end

  def test_send_pingback_found_in_body
    @body = %{<link rel="pingback" href="http://anotherblog.org/xml-rpc" />}

    assert_pingback_sent
  end

  def test_ping_sent_on_save
    Net::HTTP.next_response = self


    ping_count = XMLRPC::Client.pings.size
    art = Blog.default.articles.build \
      :body => %{<link rel="pingback" href="http://anotherblog.org/xml-rpc" />},
      :title => 'Test the pinging',
      :published => true
    assert art.save
    assert ping_count < XMLRPC::Client.pings.size
    assert art.just_published?
    art = Article.find(art.id)
    assert !art.just_published?
  end

  def assert_pingback_sent
    Net::HTTP.next_response = self
    ping = contents(:article1).pings.build("url" =>
                                           "http://anotherblog.org/a-post")

    ping.send_pingback_or_trackback("http://myblog.net/referring-post")

    sent_ping = XMLRPC::Client.pings.last
    assert_equal "http://anotherblog.org/xml-rpc", sent_ping.uri
    assert_equal "pingback.ping", sent_ping.method_name
    assert_equal "http://myblog.net/referring-post", sent_ping.args[0]
    assert_equal "http://anotherblog.org/a-post", sent_ping.args[1]
  end

  def test_send_trackback

    # We've linked to http://anotherblog.org/a-post from
    # http://myblog.net/referring-post and discovered the trackback
    # URL http://anotherblog.org/a-post/trackback
    Net::HTTP.next_response = self

    @body = <<-eobody
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
           xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
           xmlns:dc="http://purl.org/dc/elements/1.1/">
    <rdf:Description
        rdf:about=""
        trackback:ping="http://anotherblog.org/a-post/trackback"
        dc:title="Track me, track me!"
        dc:identifier="http://anotherblog.org/a-post"
        dc:description="Track me 'til I fart!'"
        dc:creator="pdcawley"
        dc:date="2006-03-01T04:31:00-05:00" />
    </rdf:RDF>
    eobody

    ping = contents(:article1).pings.build("url" =>
                                           "http://anotherblog.org/a-post")
    ping.send_pingback_or_trackback("http://myblog.net/referring-post")

    ping = Net::HTTP.pings.last
    assert_equal "anotherblog.org", ping.host
    assert_equal 80, ping.port
    assert_equal "/a-post/trackback", ping.query
    assert_equal "title=Article+1%21&excerpt=body&url=http://myblog.net/referring-post&blog_name=test+blog", ping.post_data
  end

  def test_send_weblogupdatesping

    # Our blog, named this_blog.blog_name at http://myblog.net/ has
    # changed through us posting http://myblog.net/new-post. This,
    # we'd like to tell to http://rpc.technorati.com/rpc/ping.

    ping = contents(:article1).pings.build("url" =>
                                           "http://rpc.technorati.com/rpc/ping")
    ping.send_weblogupdatesping("http://myblog.net/",
                                "http://myblog.net/new-post")

    ping = XMLRPC::Client.pings.last
    assert_equal "http://rpc.technorati.com/rpc/ping", ping.uri
    assert_equal "weblogUpdates.ping", ping.method_name
    assert_equal this_blog.blog_name, ping.args[0]
    assert_equal "http://myblog.net/", ping.args[1]
    assert_equal "http://myblog.net/new-post", ping.args[2]
  end

  # Mock stuff

  def [](key)
    @pingback_header
  end

  def body
    @body
  end
end
