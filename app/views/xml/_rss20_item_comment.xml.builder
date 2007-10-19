xm.item do
  xm.title "\"#{item.article.title}\" by #{item.author}"
  xm.description html(item)
  xm.pubDate pub_date(item.created_at)
  xm.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  xm.link item.permalink_url
end
