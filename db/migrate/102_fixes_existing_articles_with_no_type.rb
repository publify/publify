class FixesExistingArticlesWithNoType < ActiveRecord::Migration

  class Content < ActiveRecord::Base
  end
  class Article < Content
  end


  def self.up
    say "Fixes existing articles with no post types"
    Article.find(:all).each do |art|
      art.post_type = "read" if art.post_type.empty?
      art.save!
    end
  end

  def self.down
    say "This migration does absolutely nothing"
  end
end
