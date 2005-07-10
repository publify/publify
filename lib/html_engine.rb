class HtmlEngine
  
  def self.transform(txt, text_filter, restrictions = [])
    return "" if txt.blank?
    return txt if text_filter.blank?

    text_filter.split.each do |filter|
      case filter
      when "markdown": 
        txt = BlueCloth.new(txt, restrictions).to_html
      when "textile": 
        txt = self.encode_html(txt) if restrictions.include?(:filter_html)
        txt = RedCloth.new(txt, restrictions).to_html(:textile)
      when "smartypants":
        txt = RubyPants.new(txt).to_html
      end
    end

    return txt
  end

  # Taken from BlueCloth since RedCloth's filter_html is broken
  def self.encode_html( str )
    str.gsub!( "<", "&lt;" )
    str.gsub!( ">", "&gt;" )
    str
	end 

end
