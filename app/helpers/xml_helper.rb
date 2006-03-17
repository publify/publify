module XmlHelper
  def pub_date(time)
    time.rfc822
  end

  def post_title(post)
    "#{h post.title}"
  end

  def post_link(post)
    article_url(post, false)
  end

  def comment_link(comment)
    comment_url(comment, false)
  end

  def trackback_link(trackback)
    trackback_url(trackback, false)
  end

  def blog_title
    this_blog.blog_name || "Unnamed blog"
  end
end
