feed.entry item, :id => "urn:uuid:#{item.guid}", :url => item.permalink_url do |entry|
  entry.author do
    entry.name item.author
    entry.uri item.url
  end
  entry.title item.feed_title, "type"=>"html"
  entry.content html(item), "type"=>"html"
end


