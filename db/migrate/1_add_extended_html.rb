class AddExtendedHtml < ActiveRecord::Migration
  def self.up
    add_column :articles, :extended_html, :text rescue nil
    
    # now to re-process articles to set extended_html
    articles = Article.find(:all)
    puts "Processing #{articles.length} article#{'s' unless articles.length == 0}"
    articles.each { |a| a.save }
  end

  def self.down
    remove_column :articles, :extended_html
  end
end
