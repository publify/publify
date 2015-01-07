xm.url do
  xm.loc item.permalink_url
  xm.news :publication do
    xm.news :name, Blog.last.blog_name
    xm.news :language, "en"
  end
  xm.news :publication_date, item.published_at.strftime("%Y-%m-%d")
  xm.news :title, "#{item.title}"
  xm.news:keywords, item.tags.collect(&:display_name).join(', ')
end
