class Bare7Article < ActiveRecord::Base
  include BareMigration

  def stripped_title(title)
    # this is a copynpaste of the routine in article.rb
    # so the one in article.rb can change w/o breaking this.
    self.title.gsub(/<[^>]*>/,'').to_url
  end
end

class Bare7Category < ActiveRecord::Base
  include BareMigration

  def stripped_name
    # copynpaste from category.rb
    self.name.to_url
  end
end


class AddPermalink < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding categories permalink"
    Bare7Article.transaction do
      add_column :categories, :permalink, :string
      add_index :categories, :permalink

      Bare7Category.reset_column_information
      Bare7Category.find(:all).each do |c|
        c.permalink ||= c.stripped_name
        c.save!
      end

      # re-process articles to ensure correct permalinks
      Bare7Article.find(:all).each do |a|
        a.permalink = a.stripped_title() if a.attributes.include?("permalink") and a.permalink.blank?
        a.save!
      end

    end
  end

  def self.down
    STDERR.puts "Removing categories permalink"
    Bare7Article.transaction do
      remove_index :categories, :permalink
      remove_column :categories, :permalink
    end
  end
end
