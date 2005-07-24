class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Comment, Trackback, Page, Setting, Sidebar

  def after_save(record)
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record)
  end
  
  def expire_for(record)
    case record
    when Setting, Sidebar, Comment, Trackback, Article
      PageCache.sweep_all
    when Page
      PageCache.sweep("/pages/#{record.name}.html")
    end
  end
end
