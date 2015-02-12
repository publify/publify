desc "Update most popular articles"
task :generate_popular_articles => :environment do
  require File.join(Rails.root, 'lib', 'popular_article')

  most_popular_articles = MostPopularArticle.last || MostPopularArticle.new
  most_popular_articles.update_attribute(article_ids: PopularArticle.find.map(&:id))
end
