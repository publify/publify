# The methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  
  def categorylist()
    categories = Category.find_all(nil, "position")
    render_partial("shared/categories", categories)
  end
  
  def flickrlist(url)
    begin
      render_partial("shared/flickr", check_cache(Flickr, url))
    rescue 
    end 
  end

  def tadalist(url)    
    begin
      render_partial("shared/tada", check_cache(Tada, url))
    rescue 
    end 
  end

  def deliciouslist(url)    
    begin
      render_partial("shared/delicious", check_cache(Delicious, url))
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
  
  def comment_url_link(title, comment)
    link_to title, comment_url(comment)
  end  
  
  def article_url(article)
    url_for :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.stripped_title
  end

  def comment_url(comment)
    article = comment.article
    url_for :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.stripped_title, :anchor=> "comment-#{comment.id}"
  end  
  
  def responses(collection, word)
    case collection.count
    when 0
      "no #{word}s"
    when 1
      "1 #{word}"
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
  
  def check_cache(aggregator, url)
    hash = "#{aggregator.to_s}_#{Digest::SHA1.hexdigest(url)}".to_sym
    controller.cache[hash] ||= aggregator.new(url)
  end  
end
