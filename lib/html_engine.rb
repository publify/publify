class HtmlEngine
  
  def self.transform(txt)
    return "" if txt.to_s.empty?  
    RedCloth.new(txt).to_html(:textile)
  end
  
end