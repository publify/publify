feed.title(feed_title)
unless this_blog.blog_subtitle.blank?
  feed.subtitle(this_blog.blog_subtitle, "type" => "html")
end
feed.updated items.first.updated_at if items.first
feed.generator "Publify", :uri => "http://www.publify.co", :version => PUBLIFY_VERSION
