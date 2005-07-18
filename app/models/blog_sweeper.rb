class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Comment, Trackback

  def after_save(record)
    expire_xml_feeds_for(record)
    expire_static_pages_for(record)
  end
  
  def after_delete(record)
    expire_xml_feeds_for(record)
    expire_static_pages_for(record)    
  end
  
  def expire_static_pages_for(record)
    case record
    when Comment, Trackback:      
      expire_static_pages_for(record.article)
    when Article
      expire_page :controller => "/articles"
      
      (Article.count / config[:limit_article_display] ).times { |i| expire_page :controller => "/articles", :page => i+1 }      
      
      expire_page :controller => "/articles", :action =>"read", :id => record.id
      expire_page :controller => "/articles", :action =>"permalink", :year => record.created_at.year, :month => sprintf("%.2d", record.created_at.month), :day => sprintf("%.2d", record.created_at.day), :title => record.stripped_title
      expire_page :controller => "/articles", :action =>"find_by_date", :year => record.created_at.year, :month => sprintf("%.2d", record.created_at.month), :day => sprintf("%.2d", record.created_at.day)
      expire_page :controller => "/articles", :action =>"find_by_date", :year => record.created_at.year, :month => sprintf("%.2d", record.created_at.month)
      expire_page :controller => "/articles", :action =>"find_by_date", :year => record.created_at.year

      record.categories.each { |c| expire_page :controller => "/articles", :action =>"category", :id => c.name }      
    end
  end
  
  
  def expire_xml_feeds_for(record)
    case record
    when Comment, Trackback:
      expire_page :controller => "/xml", :action => ["commentrss", "trackbackrss"]
      expire_page :controller => "/xml", :action => ["articlerss"], :id => record.article.id
    when Article
      expire_page :controller => "/xml", :action => ["atom", "rss"]
    end
  end
end
