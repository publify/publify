xm.entry do
  xm.id "urn:uuid:#{item.guid}"

  xm.author do
    xm.name item.blog_name
    xm.uri item.url
  end
  xm.published item.created_at.xmlschema
  xm.updated item.updated_at.xmlschema
  xm.title "Trackback from #{item.blog_name}: #{item.title} on #{item.article.title}", "type"=>"html"

  xm.link "rel" => "alternate", "type" => "text/html", "href" => item.permalink_url

  content = item.excerpt
  xm.summary content, "type"=>"html"
end
