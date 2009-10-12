xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.instruct! 'xml-stylesheet', :type=>"text/css", :href => url_for("/stylesheets/rss.css")

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        "xmlns:trackback" => "http://madskills.com/public/xml/rss/module/trackback/" do
  xml.channel do
    xml.title feed_title
    xml.link this_blog.base_url
    xml.atom :link, :href => this_blog.url_for(params), :rel => 'self', :type => 'application/rss+xml'
    xml.language this_blog.lang.gsub("_", "-").downcase
    xml.ttl "40"
    xml.description this_blog.blog_subtitle

    rss20_feed.each do |value|
      value.to_rss(xml)
    end
  end
end
