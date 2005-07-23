class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Comment, Trackback

  def after_save(record)
    expire_xml_feeds_for(record)
    expire_static_pages_for(record)
  end

  def after_destroy(record)
    expire_xml_feeds_for(record)
    expire_static_pages_for(record)    
  end
  
  def expire_static_pages_for(record)
    case record
    when Comment, Trackback:      
      expire_static_pages_for(record.article)
    when Article
      y, m, d = record.created_at.year, sprintf("%.2d", record.created_at.month), sprintf("%.2d", record.created_at.day)

      expire_page :controller => "/articles", :action => "archives"
      
      expire_page :controller => "/articles", :action => "read", :id => record.id
      expire_page :controller => "/articles", :action => "permalink", :year => y, :month => m, :day => d, :title => record.stripped_title

      expire_page :controller => "/"
      expire_page :controller => "/articles"
      expire_page :controller => "/articles", :action => "find_by_date", :year => y, :month => m, :day => d
      expire_page :controller => "/articles", :action => "find_by_date", :year => y, :month => m
      expire_page :controller => "/articles", :action => "find_by_date", :year => y
      record.categories.each do |c|
        expire_page :controller => "/articles", :action =>"category", :id => c.name
      end

      (Article.count / config[:limit_article_display]).times do |i|
        # expire_page :controller => "/", :action => "index", :page => "page#{i+1}"
        expire_page :controller => "/articles", :page => "page#{i+1}"
        expire_page :controller => "/articles", :action => "find_by_date", :year => y, :month => m, :day => d, :page => "page#{i+1}"
        expire_page :controller => "/articles", :action => "find_by_date", :year => y, :month => m, :page => "page#{i+1}"
        expire_page :controller => "/articles", :action => "find_by_date", :year => y, :page => "page#{i+1}"
        record.categories.each do |c|
          expire_page :controller => "/articles", :action =>"category", :id => c.name, :page => "page#{i+1}"
        end
      end

    end
  end
    
  def expire_xml_feeds_for(record)
    case record
    when Comment, Trackback:
      expire_page :controller => "/xml", :action => ["commentrss", "trackbackrss"]
      expire_page :controller => "/xml", :action => "articlerss", :id => record.article.id
    when Article
      expire_page :controller => "/xml", :action => ["atom", "rss"]
    end
  end
end
