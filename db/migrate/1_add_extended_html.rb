class AddExtendedHtml < ActiveRecord::Migration
  def self.up
    add_column :articles, :extended_html, :text rescue nil
    add_column :articles, :guid, :string rescue nil
    add_column :articles, :permalink, :string rescue nil
    add_index :articles, :permalink rescue nil
    
    # now to re-process articles to set extended_html
    articles = Article.find(:all)
    puts "Processing #{articles.length} article#{'s' unless articles.length == 0}"
    articles.each { |a| a.save }
  end

  def self.down
    remove_column :articles, :extended_html
    remove_column :articles, :guid rescue nil
    remove_column :articles, :permalink rescue nil
    remove_index :articles, :permalink rescue nil
  end
end
