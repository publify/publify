module ArticlesHelper
  
  def responses(collection, word)
    case collection.count
    when 0
      "no #{word}s"
    else
      "#{collection.count} #{word}s"
    end
  end
    
  def comments_link(article)
    article_link  responses(article.comments, "comment"), article
  end

  def trackbacks_link(article)  
    article_link responses(article.trackbacks, "trackback"), article
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
  
  def page_title
    if @page_title
      @page_title
    else
      config("blog_name") || "Typo"
    end    
  end

  def article_link(title, article)
    link_to title, {:controller=>"articles", :action =>"permalink", :year => article.created_at.year, :month => article.created_at.month, :day => article.created_at.day, :title => article.stripped_title},{"title" => "Permalink to article"}
  end
end
