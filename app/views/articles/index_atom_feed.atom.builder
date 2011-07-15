atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated @articles.first.updated_at if @articles.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => TYPO_VERSION

  @articles.each do |value|
    value.to_atom(feed)
  end
end

