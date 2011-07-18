feed.item do
  feed.title item.feed_title
  feed.description html(item)
  feed.pubDate pub_date(item.created_at)
  feed.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  feed.link item.permalink_url
end

