# frozen_string_literal: true

xm.item do
  if item.is_a?(Note)
    xm.title truncate(item.html(:body).strip_html, length: 80, separator: " ",
                                                   omissions: "...")
  else
    xm.title item.title
  end
  content_html = fetch_html_content_for_feeds(item, this_blog)
  xm.description content_html + item.rss_description
  xm.pubDate item.published_at.rfc822
  xm.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  xm.dc :creator, item.author_name

  if item.is_a?(Article)
    xm.comments(item.permalink_url("comments"))
    item.tags.each do |tag|
      xm.category tag.display_name
    end
    # RSS 2.0 only allows a single enclosure per item, so only include the first one here.
    unless item.resources.empty?
      resource = item.resources.first
      xm.enclosure(
        url: item.blog.file_url(resource.upload_url),
        length: resource.size,
        type: resource.mime)
    end
  end

  xm.link item.permalink_url
end
