feed.entry item, :id => "urn:uuid:#{item.guid}", :url => item.permalink_url do |entry|
  entry.author do
    entry.name item.blog_name
    entry.uri item.url
  end
  entry.title item.feed_title, "type"=>"html"
  entry.summary item.excerpt, "type"=>"html"
end

