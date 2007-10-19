xm.item do
  xm.title "\"#{item.title}\" from #{item.blog_name} (#{item.article.title})"
  xm.description item.excerpt
  xm.pubDate pub_date(item.created_at)
  xm.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  xm.link item.url
end
