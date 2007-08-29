xml.instruct! :xml, :version=>"1.0", :encoding => "UTF-8"
xml.feed "xml:lang" => "en-US", "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title feed_title
  unless this_blog.blog_subtitle.blank?
    xml.subtitle this_blog.blog_subtitle, "type" => "html"
  end
  xml.id "tag:#{controller.request.host},2005:Typo"
  xml.generator "Typo", :uri => "http://www.typosphere.org", :version => '4.x'
  xml.link :rel => "self", :type => "application/atom+xml", \
    :href => url_for(:only_path => false, :format => :atom)
  xml.link :rel => "alternate", :type => "text/html", \
    :href => url_for(:only_path => false)

  xml.updated atom_feed.first.updated_at.xmlschema unless atom_feed.empty?

  atom_feed.each do |value|
    value.to_atom(xml)
  end
end
