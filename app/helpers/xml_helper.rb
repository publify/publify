module XmlHelper
  def pub_date(time)
    time.rfc822
  end

  def collection_lastmod(collection)
    article_updated = collection.articles.find(:first, :order => 'updated_at DESC')
    article_published = collection.articles.find(:first, :order => 'published_at DESC')

    times = []
    times.push article_updated.updated_at if article_updated
    times.push article_published.updated_at if article_published

    if times.empty?
      Time.at(0).xmlschema
    else
      times.max.xmlschema
    end
  end
end
