module ArticlesHelper
  
  def responses(article)
    case article.comments.count
    when 0
      "No Responses"
    when 1
      "One Response"
    else
      "#{article.comments.count} Responses"
    end
  end
    
  def link_to_comments(article)
    label = case article.comments.count
    when 0
      "no comments"
    when 1
      "one comment"
    else
      "#{article.comments.count} comments"
    end
    
    link_to label, :controller=> "articles", :action=>"read", :id=> article.id, :anchor=>"comments"
  end
  
  
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
end
