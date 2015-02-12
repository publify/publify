class RemoveMostPopularArticle < ActiveRecord::Migration
  def up
    drop_table :most_popular_articles
  end
end
