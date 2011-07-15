atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated @trackbacks.first.updated_at if @trackbacks.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => TYPO_VERSION

  @trackbacks.each do |item|
    render "shared/atom_item_trackback", {:feed => feed, :item => item}
  end
end
