class AddArticleGuid < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding GUID to articles"
    add_column :articles, :guid, :string rescue nil    
    Article.find(:all).each do |a|
      a.save
    end
  end

  def self.down
    remove_column :articles, :guid
  end
end
