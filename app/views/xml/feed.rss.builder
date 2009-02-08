xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.instruct! 'xml-stylesheet', :type=>"text/css", :href => url_for("/stylesheets/rss.css")

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        "xmlns:trackback" => "http://madskills.com/public/xml/rss/module/trackback/" do
  xml.channel do
    xml.title feed_title
    xml.link @link
    xml.language "en-us"
    xml.ttl "40"
    xml.description this_blog.blog_subtitle
    xml.atom :link, :href => @self_url, :rel => "self",
      :type => "application/rss+xml"

    @items.each do |item|
      render :partial => "rss20_item_#{item.class.name.to_s.downcase}",
        :locals => {:item => item, :xm => xml}
    end
  end
end
