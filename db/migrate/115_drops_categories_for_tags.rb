class DropsCategoriesForTags < ActiveRecord::Migration
  class Categorization < ActiveRecord::Base
    belongs_to :article
    belongs_to :category
  end
  
  class Category < ActiveRecord::Base
    has_many :categorizations

    has_many :articles, :through => :categorizations, :order => "published_at DESC, created_at DESC"

    default_scope order: 'name ASC'
  end
  
  def up
    # First, we migrate categories into tags
    categories = Category.find(:all)
    
    categories.each do |cat|
      # Does a tag with the same permalink exist?
      tag = Tag.find_by_name(cat.permalink)
      
      if tag.nil?
        tag = Tag.create(name: cat.permalink, display_name: cat.name)
      end
        redirect = Redirect.create(from_path: "category/#{cat.permalink}", to_path: File.join(Blog.default.base_url, "tag", tag.name))
        cat.articles.each do |article|
          article.tags << tag
          article.save
        end
    end
    
    drop_table :categorizations
    drop_table :categories
  end

  def down
  end
end
