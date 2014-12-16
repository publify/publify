module Admin::ArticleHelper
  def possible_related_articles(article)
    articles = Article.published.order('title ASC')
    articles = articles.where('id != ?', article) if article.id.present?
    articles
  end
end
