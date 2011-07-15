atom_feed do |feed|
  feed.title(feed_title)
  unless this_blog.blog_subtitle.blank?
    feed.subtitle(this_blog.blog_subtitle, "type" => "html")
  end
  feed.updated @trackbacks.first.updated_at if @trackbacks.first
  feed.generator "Typo", :uri => "http://www.typosphere.org", :version => TYPO_VERSION

  @trackbacks.each do |item|
    feed.entry item, :id => "urn:uuid:#{item.guid}", :url => item.permalink_url do |entry|
      entry.author do
        entry.name item.blog_name
        entry.uri item.url
      end
      entry.title item.feed_title, "type"=>"html"
      entry.summary item.excerpt, "type"=>"html"
    end
  end
end
