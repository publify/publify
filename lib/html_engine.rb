class HtmlEngine
  
  def self.transform(txt)
    return "" if txt.to_s.empty?
    
    # creates a nice xhtml image link to product 42 with [product-image:42]
    edited = txt.gsub(/\[product-image\:(\d*)\]/) { |match|
      begin
        digit = match.scan(/:(\d*)/)
        unit = ProductUnit.find(digit)
        "<a href=\"/shop/flypage/#{unit.id}\"><img src=\"/media/show/#{unit.thumb.id}\" alt=\"#{unit.product.title}\"/></a>"
      rescue => e
        "[error: #{e.message}]"
      end
    }
    
    RedCloth.new(edited).to_html(:textile)
  end
  
end