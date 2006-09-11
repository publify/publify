xm.item do
  xm.title post_title(item)
  xm.description html(item, this_blog.show_extended_on_rss ? :all : :body)
  xm.pubDate pub_date(item.published_at)
  xm.guid "urn:uuid:#{item.guid}", "isPermaLink" => "false"
  author = item.user.name rescue item.author
  email = item.user.email rescue nil
  author = "#{email} (#{author})" if this_blog.link_to_author unless email.blank?
  xm.author author
  xm.link item.permalink_url
  for category in item.categories
    xm.category category.name
  end
  for tag in item.tags
    xm.category tag.display_name
  end

  # RSS 2.0 only allows a single enclosure per item, so only include the first one here.
  if not item.resources.empty?
    resource = item.resources.first
    xm.enclosure(
      :url => item.blog.file_url(resource.filename),
      :length => resource.size,
      :type => resource.mime)
  end
  if item.allow_pings?
    xm.trackback :ping, item.trackback_url
  end
end
