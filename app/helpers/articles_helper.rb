module ArticlesHelper
  
  
  def render_errors(obj)
    return "" unless obj
  	tag = String.new

  	unless obj.errors.empty?
  		tag << %{<ul class="objerrors">}
  		
  		obj.errors.each_full do |message| 
  			tag << "<li>#{message}</li>"
  		end
  		
  		tag << "</ul>"
  	end
    tag
  end  
  
  def page_title
    if @page_title
      @page_title
    else
      config_value("blog_name") || "Typo"
    end    
  end

end
