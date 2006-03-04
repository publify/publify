class Bare3Article < ActiveRecord::Base
  include BareMigration
  belongs_to :user, :class_name => "Bare3User"
end

class Bare3User < ActiveRecord::Base
  include BareMigration
  has_many :articles, :class_name => "Bare3Article"
end


class AddArticleUserId < ActiveRecord::Migration
  def self.up
    STDERR.puts "Linking article authors to users"
    Bare3Article.transaction do
      add_column :articles, :user_id, :integer
  
      Bare3Article.reset_column_information
      Bare3Article.find(:all).each do |a|
        u=Bare3User.find_by_name(a.author)
        if(u)
          a.user=u
          a.save!
        end
      end
    end
  end

  def self.down
    remove_column :articles, :user_id
  end
end
