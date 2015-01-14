class AddPopularArticle < ActiveRecord::Migration
  def up
    create_table :popular_articles do |t|
    end
  end

  def down
    drop_table :popular_articles
  end
end
