module ArticlesHelper
  
  def responses(collection, word)
    case collection.count
    when 0
      "no #{word}s"
    when 1
      "one #{word}"
    else
      "#{collection.count} #{word}s"
    end
  end
    
  def link_to_comments(article)
    label = responses(article.comments, "comment")
    
    link_to label, :controller=> "articles", :action=>"read", :id=> article.id, :anchor=>"comments"
  end

  def link_to_trackbacks(article)
    label = responses(article.trackbacks, "trackback")

    link_to label, :controller=> "articles", :action=>"read", :id=> article.id, :anchor=>"trackbacks"
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
