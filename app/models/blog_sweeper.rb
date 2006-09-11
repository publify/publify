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
      sweep_pages(record)
    when Content
      if record.invalidates_cache?(destroying)
        sweep_all
      end
    when Sidebar, Category
      sweep_articles
      sweep_pages(record)
    when Blog, User
      sweep_all
    end
  end

  def sweep_all
    PageCache.sweep_all
    expire_fragment(/.*/)
  end

  def sweep_articles
    PageCache.sweep('/articles/%')
    expire_fragment(%r{.*/articles/.*})
  end

  def sweep_pages(record)
      PageCache.sweep("/pages/#{record.name rescue ''}.html")
      expire_fragment(/.*\/pages\/.*/)
      expire_fragment(/.*\/view_page.*/)
  end

  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDERR)
  end
end
