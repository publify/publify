class XmlController < ApplicationController
  
  def rss
    @articles = Article.find_all('published=1', 'created_at DESC', '10')
  end

  def atom
    @articles = Article.find_all('published=1', 'created_at DESC', '10')
  end
end
