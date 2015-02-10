require 'google_analytics/api'

class PopularArticle
  def self.find(articles_to_return=3)
    popular_articles = GoogleAnalytics::API.fetch_article_page_views
    collect_articles(popular_articles, articles_to_return) || []
  end

  protected

  def self.collect_articles(popular_articles, articles_to_return)
    popular_articles.collect do |article|
      Article.find_by(permalink: article[:label])
    end.slice(0, articles_to_return)
  end
end
