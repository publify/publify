feed.entry item, :id => "urn:uuid:#{item.guid}", :url => item.permalink_url do |entry|
  entry.author do
    name = item.user.name rescue item.author
    email = item.user.email rescue nil
    entry.name name
    entry.email email if this_blog.link_to_author unless email.blank?
  end

  entry.title item.title, "type"=>"html"

  item.categories.each do |category|
    entry.category "term" => category.permalink, "label" => category.name, "scheme" => category.permalink_url
  end
  item.tags.each do |tag|
    entry.category "term" => tag.display_name, "scheme" => tag.permalink_url
  end

  item.resources.each do |resource|
    if resource.size > 0  # The Atom spec disallows files with size=0
      entry.tag! :link, "rel" => "enclosure",
              :type => resource.mime,
              :title => item.title,
              :href => this_blog.file_url(resource.filename),
              :length => resource.size
    else
      entry.tag! :link, "rel" => "enclosure",
              :type => resource.mime,
              :title => item.title,
              :href => this_blog.file_url(resource.filename)
    end
  end
  content_html =
    if item.password_protected?
      "<p>This article is password protected. Please <a href='#{item.permalink_url}'>fill in your password</a> to read it</p>"
    elsif this_blog.hide_extended_on_rss
      html(item, :body)
    else
      html(item, :all)
    end

  entry.content content_html + item.get_rss_description, "type"=>"html"
end

