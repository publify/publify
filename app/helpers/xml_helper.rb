module XmlHelper
  def pub_date(time)
    time.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def post_title(post)
    "#{post.title}"
  end

  def post_link(post)
    server_url_for(:controller => "articles", :action => "read", :id => post.id)
  end
  
  def comment_link(comment)
    server_url_for(:controller => "articles", :action => "read", :id => comment.article.id, :anchor=> "comment-#{comment.id}")
  end  
end
