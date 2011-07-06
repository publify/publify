class AddPermalink < ActiveRecord::Migration
  class BareArticle < ActiveRecord::Base
    include BareMigration

    def stripped_title(title)
      # this is a copynpaste of the routine in article.rb
      # so the one in article.rb can change w/o breaking this.
      self.title.gsub(/<[^>]*>/,'').to_url
    end
  end

  class BareCategory < ActiveRecord::Base
    include BareMigration

    def stripped_name
      # copynpaste from category.rb
      self.name.to_url
    end
  end

  def self.up
    say "Adding categories permalink"
    modify_tables_and_update([:add_column, BareCategory, :permalink, :string],
                             [:add_index,  BareCategory, :permalink]) do
      BareCategory.find_and_update {|c| c.permalink ||= c.stripped_name }
      BareArticle.find_and_update  {|a| a.permalink ||= a.stripped_title }
    end
  end


  def self.down
    say "Removing categories permalink"
    remove_index :categories, :permalink
    remove_column :categories, :permalink
  end
end
