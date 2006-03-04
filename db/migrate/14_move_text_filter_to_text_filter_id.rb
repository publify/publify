class Bare14Article < ActiveRecord::Base
  include BareMigration
end

class Bare14Page < ActiveRecord::Base
  include BareMigration
end

class Bare14TextFilter < ActiveRecord::Base
  include BareMigration
end

class MoveTextFilterToTextFilterId < ActiveRecord::Migration
  def self.up
    STDERR.puts "Converting Article and Page to use text_filter_id instead of text_filter"
    Bare14TextFilter.transaction do
      filters=Hash.new
      Bare14TextFilter.find(:all).each do |filter|
        # Performance hack; if there are 500 articles but only 5 filters, then 
        # it's a lot faster to load them all up front.
        filters[filter.name] = filter
      end
    
      add_column :articles, :text_filter_id, :integer
      Bare14Article.reset_column_information
      Bare14Article.find(:all).each do |article|
        article.text_filter = filters[article.attributes['text_filter']]
        article.save!
      end
      remove_column :articles, :text_filter
    
      add_column :pages, :text_filter_id, :integer
      Bare14Page.reset_column_information
      Bare14Page.find(:all).each do |page|
        page.text_filter = filters[page.attributes['text_filter']]
        page.save!
      end
      remove_column :pages, :text_filter
    end
  end

  def self.down
    STDERR.puts "Dropping text_filter_id in favor of text_filter"
    Bare14TextFilter.transaction do
      add_column :articles, :text_filter, :string
      Bare14Article.reset_column_information
      Bare14Article.find(:all).each do |article|
        if(article.text_filter)
          article.attributes['text_filter'] = article.text_filter.name
        end
        article.save!
      end
      remove_column :articles, :text_filter_id
    
      add_column :pages, :text_filter, :string
      Bare14Page.reset_column_information
      Bare14Page.find(:all).each do |page|
        if(page.text_filter)
          page.attributes['text_filter'] = page.text_filter.name
        end
        page.save!
      end
      remove_column :pages, :text_filter_id
    end
  end
end
