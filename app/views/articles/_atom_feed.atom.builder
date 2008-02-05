atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated atom_feed.first.updated_at if atom_feed.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => '4.x'

  atom_feed.each do |value|
    value.to_atom(feed)
  end
end
