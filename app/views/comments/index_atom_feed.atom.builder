atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated @comments.first.updated_at if @comments.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => TYPO_VERSION

  @comments.each do |item|
    render "shared/atom_item_comment", {:feed => feed, :item => item}
  end
end

