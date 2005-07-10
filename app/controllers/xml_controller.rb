class XmlController < ApplicationController  
  caches_page :rss, :atom, :articlerss, :commentrss, :rsd, :trackbackrss

  def articlerss
    @article = Article.find(params[:id])
    @comments = @article.comments.find(:all, :order => 'created_at DESC', :limit => 25)     
  end
  
  def commentrss
    @comments = Comment.find(:all, :order => 'created_at DESC', :limit => config[:limit_rss_display])
  end
  
  def trackbackrss
    @trackbacks = Trackback.find(:all, :order => 'created_at DESC', :limit => config[:limit_rss_display])
  end
  
  def rss
    @articles = Article.find(:all, :conditions => 'published=1', :order => 'created_at DESC', :limit => config[:limit_rss_display])
  end

  def atom
    @articles = Article.find(:all, :conditions => 'published=1', :order => 'created_at DESC', :limit => config[:limit_rss_display])
  end

  def rsd
  end

end
