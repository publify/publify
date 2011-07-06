class AddArticleUserId < ActiveRecord::Migration
  class BareArticle < ActiveRecord::Base
    include BareMigration
  end

  class BareUser < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    say "Linking article authors to users"
    modify_tables_and_update(:add_column, BareArticle, :user_id, :integer) do |art|
      art.user_id = (BareUser.find_by_name(art.author).id rescue nil)
    end
    user_first = BareUser.first
    if user_first.nil?
      user_id = 1
    else
      user_id = user_first.id
    end

    BareArticle.find(:all, :conditions => 'user_id IS NULL').each do |art|
      art.user_id = user_id
      art.save!
    end
  end

  def self.down
    remove_column :articles, :user_id
  end
end
