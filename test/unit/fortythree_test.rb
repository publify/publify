require File.dirname(__FILE__) + '/../test_helper'

class FortythreeTest < Test::Unit::TestCase

  def setup
    @fortythree = Fortythree.new("", false)
    @fortythree.send(:parse, fixture)
  end

  def test_parser
    assert_equal 3, @fortythree.things.size
  end

  def test_fields
    assert_equal "43 Things: activity for anoop", @fortythree.title
    assert_equal "http://www.43things.com/people/view/anoop", @fortythree.link
  end

  def test_items
    assert_equal "Tidy my room and keep it that way", @fortythree.things[0].title
    assert_equal "http://www.43things.com/things/view/3500", @fortythree.things[0].link
  end

  private

  def fixture
    %{
  <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/">
    <channel>
      <title>43 Things: activity for anoop</title>
      <link>http://www.43things.com/people/view/anoop</link>
      <description>activity for anoop</description>
      <pubDate>Sat, 23 Apr 2005 17:01:44 GMT</pubDate>
      <lastBuildDate>Fri, 22 Apr 2005 21:38:34 GMT</lastBuildDate>
      <generator>http://www.43things.com/</generator>
      <image>
        <url>http://www.43things.com/images/icons/43-icon-31x31.gif</url>
        <link>http://www.43things.com/home</link>
        <title>43 Things Icon</title>
      </image>
      <item>
        <title>Tidy my room and keep it that way</title>
        <description>&lt;a href="http://www.43things.com/people/view/anoop"&gt;anoop&lt;/a&gt; adopted this goal</description>
        <pubDate>Fri, 22 Apr 2005 21:38:34 GMT</pubDate>
        <link>http://www.43things.com/things/view/3500</link>
        <author>nobody@43things.com (anoop)</author>
      </item>
      <item>
        <title>run a marathon</title>
        <description>&lt;a href="http://www.43things.com/people/view/anoop"&gt;anoop&lt;/a&gt; adopted this goal</description>
        <pubDate>Fri, 22 Apr 2005 20:38:48 GMT</pubDate>
        <link>http://www.43things.com/things/view/245</link>
        <author>nobody@43things.com (anoop)</author>
      </item>
      <item>
        <title>cure cancer</title>
        <description>&lt;a href="http://www.43things.com/people/view/anoop"&gt;anoop&lt;/a&gt; adopted this goal</description>
        <pubDate>Tue, 01 Mar 2005 08:33:24 GMT</pubDate>
        <link>http://www.43things.com/things/view/36857</link>
        <author>nobody@43things.com (anoop)</author>
      </item>
    </channel>
  </rss>
  }
  end
end
