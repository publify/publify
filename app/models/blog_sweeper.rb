class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Category, Comment, Trackback, Page, Blog, Sidebar

  def after_save(record)
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record)
  end

  def expire_for(record)
    case record
    when Blog, Sidebar, Category, Comment, Trackback, Article
      PageCache.sweep_all
      expire_fragment(/.*/)
    when Page
      PageCache.sweep("/pages/#{record.name}.html")
      expire_fragment(/.*\/pages\/.*/)
      expire_fragment(/.*\/view_page.*/)
    end
  end
end
