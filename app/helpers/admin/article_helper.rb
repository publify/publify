module Admin::ArticleHelper
  def possible_related_articles(article)
    Article.published.order('title ASC').where('id != ?', article)
  end
end
