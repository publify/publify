class AddContentPopularArticle < ActiveRecord::Migration
  def change
    create_table :contents_popular_articles do |t|
      t.integer :article_id, null: false
      t.integer :popular_article_id, null: false
    end
  end

  def down
    drop_table :contents_popular_articles
  end
end
