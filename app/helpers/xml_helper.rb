module XmlHelper
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def post_title(post)
    "#{h post.title}"
  end

  def post_link(post)
    server_url_for(article_url(post))
  end
  
  def comment_link(comment)
    server_url_for(comment_url(comment))
  end  
end
