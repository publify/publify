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
  
  def tag_link(tag)
    url_for :controller => "articles", :action => 'tag', :id => tag.name, :only_path => false
  end

  def collection_lastmod(collection)
    article_updated = collection.articles.find(:first, :order => 'updated_at DESC')
    article_published = collection.articles.find(:first, :order => 'published_at DESC')

    times = []
    times.push article_updated.updated_at if article_updated
    times.push article_published.updated_at if article_published

    if times.empty?
      Time.at(0).xmlschema
    else
      times.max.xmlschema
    end
  end

  def category_link(category)
    url_for :controller => "articles", :action => 'category', :id => category.permalink, :only_path => false
  end
end
