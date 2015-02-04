class RemoveContentPopularArticle < ActiveRecord::Migration
  def change
    drop_table :popular_articles
    drop_table :contents_popular_articles
  end
end
