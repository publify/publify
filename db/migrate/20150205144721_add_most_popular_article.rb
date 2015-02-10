class AddMostPopularArticle < ActiveRecord::Migration
  def up
    create_table :most_popular_articles do |t|
    end
  end

  def down
    drop_table :most_popular_articles
  end
end
