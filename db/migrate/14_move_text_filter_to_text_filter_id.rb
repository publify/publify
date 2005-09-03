class MoveTextFilterToTextFilterId < ActiveRecord::Migration
  def self.up
    STDERR.puts "Converting Article and Page to use text_filter_id instead of text_filter"
    filters=Hash.new
    TextFilter.find(:all).each do |filter|
      # Performance hack; if there are 500 articles but only 5 filters, then 
      # it's a lot faster to load them all up front.
      filters[filter.name] = filter
    end
    
    Article.transaction do
      add_column :articles, :text_filter_id, :integer
      Article.find(:all).each do |article|
        article.text_filter = filters[article.attributes['text_filter']]
        article.save
      end
      remove_column :articles, :text_filter
    end
    
    Page.transaction do
      add_column :pages, :text_filter_id, :integer
      Page.find(:all).each do |page|
        page.text_filter = filters[page.attributes['text_filter']]
        page.save
      end
      remove_column :pages, :text_filter
    end
    
  end

  def self.down
    STDERR.puts "Dropping text_filter_id in favor of text_filter"
    Article.transaction do
      add_column :articles, :text_filter, :string
      Article.find(:all).each do |article|
        if(article.text_filter)
          article.attributes['text_filter'] = article.text_filter.name
        end
        article.save
      end
      remove_column :articles, :text_filter_id
    end
    
    Page.transaction do
      add_column :pages, :text_filter, :string
      Page.find(:all).each do |page|
        if(page.text_filter)
          page.attributes['text_filter'] = page.text_filter.name
        end
        page.save
      end
      remove_column :pages, :text_filter_id
    end
  end
end
