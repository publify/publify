module XmlHelper
  def pub_date(time)
    time.rfc822
  end

  def post_title(post)
    h(post.title)
  end

  def item_link(item)
    item.location(nil, false)
  end

  alias_method :post_link,      :item_link
  alias_method :comment_link,   :item_link
  alias_method :trackback_link, :item_link

  def blog_title
    this_blog.blog_name || "Unnamed blog"
  end
end
