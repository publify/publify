# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 115)
class DropsCategoriesForTags < ActiveRecord::Migration[4.2]
  class Categorization < ActiveRecord::Base
    belongs_to :article
    belongs_to :category
  end

  class Category < ActiveRecord::Base
    has_many :categorizations
    has_many :articles, through: :categorizations
  end

  def up
    # First, we migrate categories into tags
    Category.find_each do |cat|
      # Does a tag with the same permalink exist?
      tag = Tag.find_or_create_by(name: cat.permalink) do |tg|
        tg.display_name = cat.name
      end

      Redirect.create(from_path: "category/#{cat.permalink}",
                      to_path: File.join(Blog.first.base_url, "tag", tag.name))
      cat.articles.each do |article|
        article.tags << tag
        article.save
      end
    end

    drop_table :categorizations
    drop_table :categories
  end

  def down; end
end
