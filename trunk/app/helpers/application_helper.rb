# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def categorylist()
    categories = Category.find_all(nil, "position")
    render_partial("shared/categories", categories)
  end
  
  def flickrlist(url)
    begin
      flickr = controller.cache[:flickr] || controller.cache[:flickr] = Flickr.new(url)        
      render_partial("shared/flickr", flickr)
    rescue 
    end 
  end

  def tadalist(url)    
    begin
      tada = controller.cache[:tada] || controller.cache[:tada] = Tada.new(url)

      render_partial("shared/tada", tada)
    rescue 
    end 
  end

  def deliciouslist(url)    
    begin
      delicious = controller.cache[:delicious] || controller.cache[:delicious] = Delicious.new(url)
      render_partial("shared/delicious", delicious)
    rescue 
    end 
  end

  def server_url_for(options = {})
    "http://" << @request.host << @request.port_string << url_for(options)
  end

  def strip_html(text)
    attribute_key = /[\w:_-]+/
    attribute_value = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
    attribute = /(?:#{attribute_key}(?:\s*=\s*#{attribute_value})?)/
    attributes = /(?:#{attribute}(?:\s+#{attribute})*)/
    tag_key = attribute_key
    tag = %r{<[!/?\[]?(?:#{tag_key}|--)(?:\s+#{attributes})?\s*(?:[!/?\]]+|--)?>}
    text.gsub(tag, '').gsub(/\s+/, ' ').strip
  end

  def config_value(name)  
    config[name]
  end
  
  def article_link(title, article)
    link_to title, article_url(article)
  end

  def article_url(article)
    url_for :controller=>"articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.stripped_title
  end
  
  def comment_url(comment)
    article = comment.article
    url_for :controller=>"articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.stripped_title, :anchor=> "comment-#{comment.id}"
  end
  
  
end
