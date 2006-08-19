require File.dirname(__FILE__) + '/../test_helper'

class MagnoliaTest < Test::Unit::TestCase

  def setup
    @mag = ::MagnoliaAggregation.new("",false)
    @mag.send(:parse, fixture)
  end

  def test_parser
    assert_equal 3, @mag.pics.size
  end

  def test_random_chooser
    assert_equal 2, @mag.choose(2).size
  end

  def test_fields
    assert_equal "Ma.gnolia: steve.longdo's Recent Bookmarks", @mag.title
    assert_equal "http://ma.gnolia.com/rss/full/people/steve.longdo", @mag.link
    assert_equal "steve.longdo's Recent Bookmarks", @mag.description
  end

  def test_image
    assert_equal "Typo Administration: article tagging II...", @mag.pics[1].title
    assert_equal "http://ma.gnolia.com/bookmarks/cestusisc/dispatch", @mag.pics[1].link
    assert_not_nil @mag.pics[1].description
    assert_equal Time.parse("Thu,  9 March 2006 00:54:22 PST"), @mag.pics[1].date
  end

  def test_image_desc_parser
    assert_equal "http://scst.srv.girafa.com/srv/i?i=sc010159&amp;r=http://www.stevelongdo.com/articles/2006/03/08/typo-administration-article-tagging-ii&amp;s=2c760cc2f54920b7", @mag.pics[1].image
  end

  private

  def fixture
    %{<?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
       <channel>
         <title>Ma.gnolia: steve.longdo's Recent Bookmarks</title>
         <link>http://ma.gnolia.com/rss/full/people/steve.longdo</link>
         <language>en-us</language>
         <ttl>40</ttl>
         <description>steve.longdo's Recent Bookmarks</description>
         <item>
           <title>Using a Proxy class for debugging</title>
           <author>steve.longdo</author>
           <description type="html">&lt;p&gt;&lt;a href="http://ma.gnolia.com/bookmarks/qawatech/dispatch"&gt;&lt;img alt="Using-a-proxy-class-for-debugging&amp;amp;s=55dc698e9016ced0" src="http://scst.srv.girafa.com/srv/i?i=sc010159&amp;amp;r=http://habtm.com/articles/2006/03/06/using-a-proxy-class-for-debugging&amp;amp;s=55dc698e9016ced0" /&gt;&lt;/a&gt;&lt;/p&gt;

        &lt;p&gt;No Description&lt;/p&gt;

        &lt;p&gt;&lt;b&gt;Tags:&lt;/b&gt; &lt;/p&gt;</description>
           <pubDate>Fri, 10 March 2006 22:16:24 PST</pubDate>
           <guid>http://ma.gnolia.com/bookmarks/qawatech</guid>
           <link>http://ma.gnolia.com/bookmarks/qawatech/dispatch</link>
         </item>
         <item>
           <title>Typo Administration: article tagging II...</title>
           <author>steve.longdo</author>
           <description type="html">&lt;p&gt;&lt;a href="http://ma.gnolia.com/bookmarks/cestusisc/dispatch"&gt;&lt;img alt="Typo-administration-article-tagging-ii&amp;amp;s=2c760cc2f54920b7" src="http://scst.srv.girafa.com/srv/i?i=sc010159&amp;amp;r=http://www.stevelongdo.com/articles/2006/03/08/typo-administration-article-tagging-ii&amp;amp;s=2c760cc2f54920b7" /&gt;&lt;/a&gt;&lt;/p&gt;

        &lt;p&gt;No Description&lt;/p&gt;

        &lt;p&gt;&lt;b&gt;Tags:&lt;/b&gt; &lt;/p&gt;</description>
           <pubDate>Thu,  9 March 2006 00:54:22 PST</pubDate>
           <guid>http://ma.gnolia.com/bookmarks/cestusisc</guid>
           <link>http://ma.gnolia.com/bookmarks/cestusisc/dispatch</link>
         </item>
         <item>
           <title>FireBug - JS/AJAX/CSS/Chops Veggies?</title>
           <author>steve.longdo</author>
           <description type="html">&lt;p&gt;&lt;a href="http://ma.gnolia.com/bookmarks/showuw/dispatch"&gt;&lt;img alt="&amp;amp;s=1c7bf627bbfc8164" src="http://scst.srv.girafa.com/srv/i?i=sc010159&amp;amp;r=http://www.joehewitt.com/software/firebug/&amp;amp;s=1c7bf627bbfc8164" /&gt;&lt;/a&gt;&lt;/p&gt;

        &lt;p&gt;&lt;/p&gt;

        &lt;p&gt;&lt;b&gt;Tags:&lt;/b&gt; &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/firefox" rel="tag" title="Find steve.longdo bookmarks tagged 'firefox'"&gt;firefox&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/javascript" rel="tag" title="Find steve.longdo bookmarks tagged 'javascript'"&gt;javascript&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/ajax" rel="tag" title="Find steve.longdo bookmarks tagged 'ajax'"&gt;ajax&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/extension" rel="tag" title="Find steve.longdo bookmarks tagged 'extension'"&gt;extension&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/debugging" rel="tag" title="Find steve.longdo bookmarks tagged 'debugging'"&gt;debugging&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/development" rel="tag" title="Find steve.longdo bookmarks tagged 'development'"&gt;development&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/programming" rel="tag" title="Find steve.longdo bookmarks tagged 'programming'"&gt;programming&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/tools" rel="tag" title="Find steve.longdo bookmarks tagged 'tools'"&gt;tools&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/web" rel="tag" title="Find steve.longdo bookmarks tagged 'web'"&gt;web&lt;/a&gt;, &lt;a href="http://ma.gnolia.com/people/steve.longdo/tags/imported" rel="tag" title="Find steve.longdo bookmarks tagged 'imported'"&gt;imported&lt;/a&gt;&lt;/p&gt;</description>
           <pubDate>Tue,  7 March 2006 23:32:19 PST</pubDate>
           <guid>http://ma.gnolia.com/bookmarks/showuw</guid>
           <link>http://ma.gnolia.com/bookmarks/showuw/dispatch</link>
         </item>
       </channel>
    </rss>
}
  end

end
