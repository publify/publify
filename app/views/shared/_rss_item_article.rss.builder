xm.item do
  if item.is_a?(Note)
    xm.title truncate(item.html(:body).strip_html, length: 80, separator: ' ', omissions: '...')
  else
    xm.title item.title
  end
  content_html = fetch_html_content_for_feeds(item, this_blog)
  xm.description content_html + item.get_rss_description
  xm.pubDate item.published_at.rfc822
  xm.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  if item.link_to_author?
    xm.author "#{item.user.email} (#{item.user.name})"
  end

  if item.is_a?(Article)
    xm.comments(item.permalink_url("comments"))
    for tag in item.tags
      xm.category tag.display_name
    end
    # RSS 2.0 only allows a single enclosure per item, so only include the first one here.
    if not item.resources.empty?
      resource = item.resources.first
      xm.enclosure(
        :url => item.blog.file_url(resource.upload_url),
        :length => resource.size,
        :type => resource.mime)
      end
    end

  if item.allow_pings?
    xm.trackback :ping, item.trackback_url
  end
  xm.link item.permalink_url
end

