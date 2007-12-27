xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed "xml:lang" => "en-US", "xmlns" => 'http://www.w3.org/2005/Atom' do
  xml.title feed_title
  if(not this_blog.blog_subtitle.blank?)
    xml.subtitle this_blog.blog_subtitle, "type"=>"html"
  end
  xml.id "tag:#{@controller.request.host},2005:Typo"
  xml.generator "Typo", :uri => "http://www.typosphere.org", :version => '4.0'
  xml.link "rel" => "self", "type" => "application/atom+xml", "href" => url_for(:only_path => false)
  xml.link "rel" => "alternate", "type" => "text/html", "href" => @link

  xml.updated @items.first.updated_at.xmlschema unless @items.empty?

  @items.each do |item|
    render :partial => "atom10_item_#{item.class.name.to_s.downcase}",
      :locals => {:item => item, :xm => xml}
  end
end
