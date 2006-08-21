class BlogSweeper < ActionController::Caching::Sweeper
  observe Article, Category, Feedback, Page, Blog, Sidebar, User

  def after_save(record)
    logger.info "Expiring #{record}, with controller: #{controller}"
    expire_for(record)
  end

  def after_destroy(record)
    expire_for(record, true)
  end

  def expire_for(record, destroying = false)
    case record
    when Page
      sweep_pages
    when Content
      if content_is_sweepable?(record, destroying)
        sweep_all
      end
    when Sidebar, Category
      sweep_articles
      sweep_pages
    when Blog, User
      sweep_all
    end
  end

  def content_is_sweepable?(record, destroying)
    destroying ? record.published? : record.just_changed_published_status?
  end

  def sweep_all
    PageCache.sweep_all
    expire_fragment(/.*/)
  end

  def sweep_articles
    PageCache.sweep('/articles/%')
    expire_fragment(%r{.*/articles/.*})
  end

  def sweep_pages
      PageCache.sweep("/pages/#{record.name}.html")
      expire_fragment(/.*\/pages\/.*/)
      expire_fragment(/.*\/view_page.*/)
  end
end
