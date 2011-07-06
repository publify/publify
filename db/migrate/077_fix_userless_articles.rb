class FixUserlessArticles < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end
  class Content < ActiveRecord::Base
  end
  class Article < Content
  end

  def self.up
    unless $schema_generator
      articles = Article.find(:all)
      say "Fixing articles with empty user_id"

      articles.each do |article|
        if article.user.nil?
          say "Fixing article #{article.id} having empty user", true
          article.user_id = 1
          article.save!
        end
      end
    end
  end

  def self.down

  end
end
