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
      STDERR.puts "Fixing articles with empty user_id"

      articles.each do |article|
        if article.user.nil?
          STDERR.puts "Fixing article #{article.id} having empty user"
          article.user_id = 1
          article.save!
        end
      end
    end
  end

  def self.down

  end
end
