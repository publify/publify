class HtmlEngine
  
  def self.transform(txt, text_filter = 'textile')
    return "" if txt.to_s.empty?  
    
    if text_filter == "markdown"
      BlueCloth.new(txt).to_html
    else
      RedCloth.new(txt).to_html(:textile)
    end
  end
  
end