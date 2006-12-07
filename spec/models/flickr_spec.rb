require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a parsed flickr fixture with six items' do
  setup do
    @flickr = FlickrAggregation.new('', false)
    @flickr.send(:parse, fixture)
  end

  specify 'there should be 6 pictures' do
    @flickr.should_have(6).pics
  end

  specify 'choose(4) should pick 4 pictures at random' do
    @flickr.should_have(4).choose(4)
  end

  specify 'port of test_fields' do
    @flickr.title.should == "xal's Photos"
    @flickr.link.should == "http://www.flickr.com/photos/40235412@N00/"
    @flickr.description.should == "A feed of xal's Photos"
  end

  specify 'port of test_image' do
    @flickr.pics[0].title.should == "p1010009"
    @flickr.pics[0].link.should == "http://www.flickr.com/photos/40235412@N00/4903142/"
    @flickr.pics[0].description.should_not_be nil
    @flickr.pics[0].date.should == Time.parse("Wed, 16 Feb 2005 07:15:48 -0800")
  end

  specify 'port of test_image_desc_parsers' do
    @flickr.pics[0].image.should == "http://photos3.flickr.com/4903142_ada4539ae8_m.jpg"
    @flickr.pics[0].thumb.should == "http://photos3.flickr.com/4903142_ada4539ae8_t.jpg"
  end

  def fixture
    %{<?xml version="1.0" encoding="utf-8"?>
    <rss version="2.0">
        <channel>
            <title>xal's Photos</title>
            <link>http://www.flickr.com/photos/40235412@N00/</link>
            <description>A feed of xal's Photos</description>
            <pubDate>Wed, 16 Feb 2005 07:15:48 -0800</pubDate>
            <lastBuildDate>Wed, 16 Feb 2005 07:15:48 -0800</lastBuildDate>
            <generator>http://www.flickr.com/</generator>
            <image>
                <url>http://www.flickr.com/images/buddyicon.jpg?40235412@N00</url>
                <title>xals Photos</title>
                <link>http://www.flickr.com/photos/40235412@N00/</link>
            </image>

            <item>
                <title>p1010009</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903142/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903142/&quot; title=&quot;p1010009&quot;&gt;&lt;img src=&quot;http://photos3.flickr.com/4903142_ada4539ae8_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;p1010009&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:15:48 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903142</guid>
            </item>
            <item>
                <title>IMG_2472</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903134/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903134/&quot; title=&quot;IMG_2472&quot;&gt;&lt;img src=&quot;http://photos5.flickr.com/4903134_c21069ee3d_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;IMG_2472&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:15:28 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903134</guid>
            </item>
            <item>
                <title>IMG_2463</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903116/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903116/&quot; title=&quot;IMG_2463&quot;&gt;&lt;img src=&quot;http://photos4.flickr.com/4903116_27512793a4_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;IMG_2463&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:14:57 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903116</guid>
            </item>
            <item>
                <title>IMG_2367</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903079/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903079/&quot; title=&quot;IMG_2367&quot;&gt;&lt;img src=&quot;http://photos4.flickr.com/4903079_7a2cbb125b_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;IMG_2367&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:14:36 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903079</guid>
            </item>
            <item>
                <title>IMG_2365</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903059/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903059/&quot; title=&quot;IMG_2365&quot;&gt;&lt;img src=&quot;http://photos5.flickr.com/4903059_72a2d9ca1e_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;IMG_2365&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:14:17 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903059</guid>
            </item>
            <item>
                <title>IMG_2201</title>
                <link>http://www.flickr.com/photos/40235412@N00/4903030/</link>
                <description>&lt;p&gt;&lt;a href=&quot;http://www.flickr.com/people/40235412@N00/&quot;&gt;xal&lt;/a&gt; posted a photo:&lt;/p&gt;

    &lt;p&gt;&lt;a href=&quot;http://www.flickr.com/photos/40235412@N00/4903030/&quot; title=&quot;IMG_2201&quot;&gt;&lt;img src=&quot;http://photos5.flickr.com/4903030_9a7fcb492e_m.jpg&quot; width=&quot;240&quot; height=&quot;180&quot; alt=&quot;IMG_2201&quot; style=&quot;border: 1px solid #000000;&quot; /&gt;&lt;/a&gt;&lt;/p&gt;

    </description>
                <pubDate>Wed, 16 Feb 2005 07:13:59 -0800</pubDate>
                <author>nobody@flickr.com (xal)</author>
                <guid isPermaLink="false">tag:flickr.com,2004:/photo/4903030</guid>
            </item>

        </channel>
    </rss>
}
  end
end
