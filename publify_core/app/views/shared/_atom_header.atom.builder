feed.title(feed_title)
if this_blog.blog_subtitle.present?
  feed.subtitle(this_blog.blog_subtitle, 'type' => 'html')
end
feed.updated items.first.updated_at if items.first
feed.generator 'Publify', uri: 'http://www.publify.co', version: PublifyCore::VERSION
