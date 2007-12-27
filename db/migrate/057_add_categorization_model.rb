class AddCategorizationModel < ActiveRecord::Migration
  class ArticlesCategory < ActiveRecord::Base
    include BareMigration
  end

  class Categorization < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    create_table :categorizations do |t|
      t.column :article_id, :integer
      t.column :category_id, :integer
      t.column :is_primary, :boolean
    end

    unless $schema_generator
      ArticlesCategory.find(:all).each do |ac|
        Categorization.create!(:article_id => ac.article_id,
                               :category_id => ac.category_id,
                               :is_primary => (ac.is_primary == 1))
      end rescue nil
    end

    drop_table :articles_categories rescue nil
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
