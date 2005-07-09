class XmlController < ApplicationController  
  caches_page :rss, :atom, :articlerss, :commentrss, :rsd

  def articlerss
    @article = Article.find(params[:id])
    @comments = @article.comments.find(:all, :order => 'created_at DESC', :limit => 25)     
  end
  
  def commentrss
    @comments = Comment.find(:all, :order => 'created_at DESC', :limit => 10)
  end
  
  def rss
    @articles = Article.find(:all, :conditions => 'published=1', :order => 'created_at DESC', :limit => 10)
  end

  def atom
    @articles = Article.find(:all, :conditions => 'published=1', :order => 'created_at DESC', :limit => 10)
  end

  def rsd
  end

end
