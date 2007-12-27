class AddArticleUserId < ActiveRecord::Migration
  class BareArticle < ActiveRecord::Base
    include BareMigration
  end

  class BareUser < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    STDERR.puts "Linking article authors to users"
    modify_tables_and_update(:add_column, BareArticle, :user_id, :integer) do |art|
      art.user_id = (BareUser.find_by_name(art.author).id rescue nil)
    end
  end

  def self.down
    remove_column :articles, :user_id
  end
end
