class AddPermalink < ActiveRecord::Migration
  def self.up
    Article.reset_column_information
    
    add_column :articles, :permalink, :string rescue nil
    add_index :articles, :permalink rescue nil

    add_column :categories, :permalink, :string
    add_index :categories, :permalink

    # now to re-process articles and categories to set permalinks
    articles = Article.find(:all)
    puts "Processing #{articles.length} article#{'s' unless articles.length == 1}"
    articles.each { |a| a.save }
    
    categories = Category.find(:all)
    puts "Processing #{categories.length} categorie#{'s' unless categories.length == 1}"
    categories.each { |c| c.save }
  end

  def self.down
    remove_index :articles, :permalink
    remove_column :articles, :permalink
    
    remove_index :categories, :permalink
    remove_column :categories, :permalink
  end
end
