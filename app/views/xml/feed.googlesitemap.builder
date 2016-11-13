xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.urlset "xmlns"=>"http://www.google.com/schemas/sitemap/0.84" do
  @items.each do |item|
    render "googlesitemap_item_#{item.class.name.to_s.downcase}",
      {:item => item, :xm => xml}
  end
end
