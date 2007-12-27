xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.instruct! 'xml-stylesheet', :type=>"text/css", :href => url_for("/stylesheets/rss.css")

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:trackback" => "http://madskills.com/public/xml/rss/module/trackback/" do
  xml.channel do
    xml.title feed_title
    xml.link url_for(:only_path => false, :format => :rss)
    xml.language "en-us"
    xml.ttl "40"
    xml.description this_blog.blog_subtitle

    rss20_feed.each do |value|
      value.to_rss(xml)
    end
  end
end
