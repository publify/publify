class HtmlEngine
  
  def self.transform(txt, text_filter = 'textile')
    return "" if txt.to_s.empty?  
    
    case text_filter
      when "markdown": BlueCloth.new(txt).to_html
      when "textile": RedCloth.new(txt).to_html(:textile)
      else txt
    end
  end
  
end