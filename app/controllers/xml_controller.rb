class XmlController < ApplicationController
  
  caches_page :rss, :atom, :commentrss

  def commentrss
    @comments = Comment.find_all(nil, 'created_at DESC', '10')
  end
  
  def rss
    @articles = Article.find_all('published=1', 'created_at DESC', '10')
  end

  def atom
    @articles = Article.find_all('published=1', 'created_at DESC', '10')
  end

  def rsd
  end

end
