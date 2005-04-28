require 'syntax/convertors/html'

class HtmlEngine
  
  def self.transform(txt, text_filter = 'textile', restrictions = [])
    return "" if txt.to_s.empty?  
    
    case text_filter
      when "markdown": BlueCloth.new(txt, restrictions).to_html
      when "textile": 
        txt = self.encode_html(txt) if restrictions.include?(:filter_html)
        RedCloth.new(txt, restrictions).to_html(:textile)
      else txt
    end
  end

  # Taken from BlueCloth since RedCloth's filter_html is broken
  def self.encode_html( str )
    str.gsub!( "<", "&lt;" )
    str.gsub!( ">", "&gt;" )
    str
	end 
	
	def self.colorcode( str )
	  
	end


end