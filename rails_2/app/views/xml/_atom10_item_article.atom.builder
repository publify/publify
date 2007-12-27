xm.entry do
  xm.author do
    name = item.user.name rescue item.author
    email = item.user.email rescue nil
    xm.name name
    xm.email email if this_blog.link_to_author unless email.blank?
  end
  xm.id "urn:uuid:#{item.guid}"

  xm.published item.published_at.xmlschema
  xm.updated item.updated_at.xmlschema
  xm.title post_title(item), "type"=>"html"

  xm.link "rel" => "alternate", "type" => "text/html", "href" => item.permalink_url

  item.categories.each do |category|
    xm.category "term" => category.permalink, "label" => category.name, "scheme" => category.permalink_url
  end
  item.tags.each do |tag|
    xm.category "term" => tag.display_name, "scheme" => tag.permalink_url
  end

  item.resources.each do |resource|
    if resource.size > 0  # The Atom spec disallows files with size=0
      xm.link "rel" => "enclosure",
              :type => resource.mime,
              :title => item.title,
              :href => this_blog.file_url(resource.filename),
              :length => resource.size
    else
      xm.link "rel" => "enclosure",
              :type => resource.mime,
              :title => item.title,
              :href => this_blog.file_url(resource.filename)
    end
  end
  xm.summary html(item, :body), "type"=>"html"
  if this_blog.show_extended_on_rss
    xm.content html(item, :all), "type"=>"html" if this_blog.show_extended_on_rss 
  end
end
