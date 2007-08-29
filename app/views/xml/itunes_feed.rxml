xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.instruct! 'xml-stylesheet', :type=>"text/css", :href => url_for("/stylesheets/rss.css")

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:trackback" => "http://madskills.com/public/xml/rss/module/trackback/",
        "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do

  xml.channel do
    xml.title feed_title
    xml.link @link
    xml.language "en-us"
    xml.ttl "40"
    xml.description this_blog.blog_subtitle

    xml.itunes :author,(this_blog.itunes_author)
    xml.itunes :subtitle,(this_blog.itunes_subtitle)
    xml.itunes :summary,(this_blog.itunes_summary)
    xml.itunes :owner do
      xml.itunes :name,(this_blog.itunes_name)
      xml.itunes :email,(this_blog.itunes_email)
    end
    xml.copyright(this_blog.itunes_copyright)

    @items.each do |item|
      render :partial => "itunes_item_resource",
        :locals => {:item => item, :xm => xml}
    end
  end
end
