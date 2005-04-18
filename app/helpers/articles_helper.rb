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
  
  def article_links(article)
    returning code = [] do
      code << category_links(article)   unless article.categories.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end
  
  def category_links(article)
    "Posted in " + article.categories.collect { |c| link_to c.name, :controller=>"articles", :action=>"category", :id=>c.name }.join(", ")
  end

end
