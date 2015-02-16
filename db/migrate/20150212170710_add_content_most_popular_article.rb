class AddContentMostPopularArticle < ActiveRecord::Migration
  def up
    create_table :contents_most_popular_articles do |t|
      t.references :article
      t.references :most_popular_article
    end
  end

  def down
    drop_table :contents_most_popular_articles
  end
end
