class Title
  def self.dedup(article)
    others = Article.where({title: article.title})
    .where(published_at: article.published_at).order('title')
    return article.permalink if others.empty?
    others.first.title + "-#{others.size+1}"
  end
end
