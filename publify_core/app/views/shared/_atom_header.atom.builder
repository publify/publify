feed.title(feed_title)
feed.subtitle(this_blog.blog_subtitle, 'type' => 'html') if this_blog.blog_subtitle.present?
feed.updated items.first.updated_at if items.first
feed.generator 'Publify', uri: 'http://www.publify.co', version: PublifyCore::VERSION
