if item.is_a?(Note)
  json.title truncate(item.html(:body).strip_html, length: 80, separator: ' ', omissions: '...')
else
  json.title item.title
end
content_html = fetch_html_content_for_feeds(item, this_blog)
json.description content_html + item.get_rss_description
json.pubDate item.published_at.rfc822

json.link item.permalink_url
