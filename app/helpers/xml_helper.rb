module XmlHelper
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def post_title(post)
    "#{h post.title}"
  end

  def post_link(post)
    article_url(post, true)
  end
  
  def comment_link(comment)
    comment_url(comment, true)
  end  
  
  def blog_title
    config_value("blog_name") || "Unnamed blog"
  end
end
