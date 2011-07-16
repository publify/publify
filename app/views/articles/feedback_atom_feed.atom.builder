atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated @feedback.first.updated_at if @feedback.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => TYPO_VERSION

  @feedback.each do |item|
    render "shared/atom_item_#{item.type.downcase}", {:feed => feed, :item => item}
  end
end

