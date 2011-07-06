class AddCategorizationModel < ActiveRecord::Migration
  class ArticlesCategory < ActiveRecord::Base
    include BareMigration
  end

  class Categorization < ActiveRecord::Base
    include BareMigration
  end

  class User < ActiveRecord::Base
  end
  class Content < ActiveRecord::Base
  end
  class Article < Content
  end
  class Category < ActiveRecord::Base
  end

  def self.up
    create_table :categorizations do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
      t.column :is_primary, :boolean
    end

    unless $schema_generator
      # You need test if ArticlesCategory object exist because if
      # exception raise even rescue in migration and migration failed and stop
      # :(
      if table_exists? :articles_categories
        ArticlesCategory.all.each do |ac|
          Categorization.create!(:article_id => ac.article_id,
                                 :category_id => ac.category_id,
                                 :is_primary => (ac.is_primary == 1))
        end
        drop_table :articles_categories
      end
    end
    # Adds the article category to the first post if and only if generating the schema
    if User.count.zero?
      article = Article.find(:first)
      category = Category.find(:first)
      say "Adding category to default article"
      unless article.nil? or category.nil?
        Categorization.create!(:article_id => article.id,
                               :category_id => category.id,
                               :is_primary => 1)
      end
    end
  end

  def self.down
    create_table :articles_categories, :id => false do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
      t.column :is_primary, :integer
    end

    unless $schema_generator
      Categorization.find(:all).each do |c|
        ArticlesCategory.create!(:article_id => c.article_id,
                                 :category_id => c.category_id,
                                 :is_primary => c.is_primary ? 1 : 0)
      end
    end

    drop_table :categorizations
  end
end
