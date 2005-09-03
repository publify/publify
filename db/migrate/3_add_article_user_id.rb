class AddArticleUserId < ActiveRecord::Migration
  def self.up
    add_column :articles, :user_id, :integer

    STDERR.puts "Linking article authors to users"
    Article.find(:all).each do |a|
      u=User.find_by_name(a.author)
      if(u)
        a.user=u
        a.save
      end
    end
  end

  def self.down
    remove_column :articles, :user_id
  end
end
