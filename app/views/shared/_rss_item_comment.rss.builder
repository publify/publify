feed.item do
  feed.title item.feed_title
  feed.description html(item)
  feed.pubDate item.created_at.rfc822
  feed.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  feed.link item.permalink_url
end

