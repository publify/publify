class DropsTypoReferencesForPublify < ActiveRecord::Migration

  class Content < ActiveRecord::Base
  end
  class Article < Content
  end
  class Page < Content
  end
  
  def self.up
    say "Removes references to typo:something from articles, pages, feedback"
    unless Blog.default.nil?
      blog = Blog.default
      blog.plugin_avatar = "PublifyPlugins::Gravatar" if blog.plugin_avatar == "TypoPlugins::Gravatar"
      blog.save!
    end
    
    Article.find_each do |art|
      art.body.gsub!("<typo:", "<publify:")
      art.body.gsub!("</typo:", "</publify:")
      art.extended.gsub!("<typo:", "<publify:")
      art.extended.gsub!("</typo:", "</publify:")
      art.excerpt.gsub!("<typo:", "<publify:")
      art.excerpt.gsub!("</typo:", "</publify:")
      art.save!
    end
    
    Page.find_each do |page|
      page.body.gsub!("<typo:", "<publify:")
      page.body.gsub!("</typo:", "</publify:")
      page.extended.gsub!("<typo:", "<publify:")
      page.extended.gsub!("</typo:", "</publify:")
      page.excerpt.gsub!("<typo:", "<publify:")
      page.excerpt.gsub!("</typo:", "</publify:")
      page.save!
    end

    Feedback.find_each do |feedback|
      feedback.body.gsub!("<typo:", "<publify:")
      feedback.body.gsub!("</typo:", "</publify:")
      feedback.save!
    end
    
  end

  def self.down
    say "This migration does absolutely nothing"
  end
end
