class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Category, Comment, Trackback, Page, Setting, Sidebar

  def after_update(record)
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record)
    expire_siblings_of(record)
    expire_parents_of(record)
  end

  alias_method :after_create, :after_destroy

  def expire_paths(pattern)
    PageCache.destroy_and_list(pattern).each {|p| self.expire_page(p) rescue nil}
  end

  def expire_for(record)
    case record
    when Content
      record.cached_pages.each do |p|
        self.expire_page p.name
        p.destroy
      end
    when Setting, Sidebar
      expire_paths(:all)
    end
  end
  
  def expire_siblings_of(record)
    case record
    when Setting, Sidebar, Category, Article
      expire_paths(:all)
    when Page
    end
  end

  def expire_parents_of(record)
    case record
    when Comment, Trackback
      expire_for(record.article)
    end
  end

end
