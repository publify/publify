# frozen_string_literal: true

feed.entry(item, id: "urn:uuid:#{item.guid}", published: item.published_at,
                 url: item.permalink_url) do |entry|
  entry.author do
    entry.name item.author_name
  end

  if item.is_a?(Note)
    truncated_body = truncate(item.html(:body).strip_html,
                              length: 80, separator: " ", omissions: "...")
    entry.title truncated_body, "type" => "html"
  else
    entry.title item.title, "type" => "html"
  end

  if item.is_a?(Article)

    item.tags.each do |tag|
      entry.category "term" => tag.display_name, "scheme" => tag_url(tag.permalink)
    end

    # TODO: Add tests for this
    item.resources.each do |resource|
      link_options = { rel: "enclosure",
                       type: resource.mime,
                       title: item.title,
                       href: this_blog.file_url(resource.upload_url) }
      # The Atom spec disallows files with size=0
      link_options[:length] = resource.size if resource.size > 0
      entry.tag! :link, link_options
    end
  end
  content_html = fetch_html_content_for_feeds(item, this_blog)
  entry.content content_html + item.rss_description, "type" => "html"
end
