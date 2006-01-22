class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Category, Comment, Trackback, Page, Setting, Sidebar

  def after_save(record)
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record)
  end
  
  def expire_for(record)
    case record
    when Setting, Sidebar, Category, Comment, Trackback, Article
      PageCache.sweep_all
      expire_fragment(/.*/)
    when Page
      PageCache.sweep("/pages/#{record.name}.html")
      expire_fragment(/.*\/pages\/.*/)
    end
  end
end
