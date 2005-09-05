class XmlController < ApplicationController  
  caches_page :feed
  
  FORMATS = {'atom' => 'atom03', 'rss' => 'rss20', 
    'atom03' => nil, 'atom10' => nil, 'rss20' => nil}
  
  def feed
    @items = Array.new
    @format = params[:format]
    
    @feed_title = config[:blog_name]
    @link = url_for({:controller => "articles"},{:only_path => false})
    
    if not FORMATS.include?(@format)
      render :text => 'Unsupported format', :status => 404
      return
    end
    
    if FORMATS[@format]
      @format = FORMATS[@format]
    end
    
    case params[:type]
    when 'feed'
      @items = Article.find(:all, :order => 'created_at DESC', 
        :conditions => 'published=1', :limit => config[:limit_rss_display])
    when 'comments'
      @items = Comment.find(:all, :order => 'created_at DESC', :limit => config[:limit_rss_display])
      @feed_title = "#{config[:blog_name]} comments"
    when 'trackbacks'
      @items = Trackback.find(:all, :order => 'created_at DESC', :limit => config[:limit_rss_display])
      @feed_title = "#{config[:blog_name]} trackbacks"
    when 'article'
      article = Article.find(params[:id])
      @items = article.comments.find(:all, :order => 'created_at DESC', :limit => 25)
      @items.push(article)
      @feed_title = "#{config[:blog_name]}: #{article.title}"
      @link = article_url(article, false)
    when 'category'
      category = Category.find_by_permalink(params[:id])
      @items = Article.find_published_by_category_permalink(params[:id], :limit => config[:limit_rss_display])
      @feed_title = "#{config[:blog_name]}: Category #{category.name}"
      @link = url_for({:controller => "articles", :action => "category", :id => category.permalink},
        {:only_path => false})
    when 'tag'
      tag = Tag.find_by_name(params[:id])
      @items = Article.find_published_by_tag_name(params[:id], :limit => config[:limit_rss_display])
      @feed_title = "#{config[:blog_name]}: Tag #{tag.name}"
      @link = url_for({:controller => "articles", :action => 'tag', :tag => tag.name},
        {:only_path => false})
    else
      render :text => 'Unsupported action', :status => 404
      return
    end
    
    render :action => "#{@format}_feed"
  end

  def articlerss
    redirect_to :action => 'feed', :format => 'rss20', :type => 'article', :id => params[:id]
  end
  
  def commentrss
    redirect_to :action => 'feed', :format => 'rss20', :type => 'comments'
  end
  def trackbackrss
    redirect_to :action => 'feed', :format => 'rss20', :type => 'trackbacks'
  end

  def rsd
  end
end
