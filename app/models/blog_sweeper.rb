class BlogSweeper < ActionController::Caching::Sweeper
  observe Category, Blog, Sidebar, User, Article, Page, Categorization

  def after_comments_create
    expire_for(controller.send(:instance_variable_get, :@comment))
  end

  alias_method :after_comments_update, :after_comments_create
  alias_method :after_articles_comment, :after_comments_create

  def after_comments_destroy
    expire_for(controller.send(:instance_variable_get, :@comment), true)
  end

  alias_method :after_articles_nuke_comment, :after_comments_destroy

  def after_articles_trackback
    expire_for(controller.send(:instance_variable_get, :@trackback))
  end

  def after_articles_nuke_trackback
    expire_for(controller.send(:instance_variable_get, :@trackback), true)
  end

  def after_save(record)
    logger.info "Expiring #{record}, with controller: #{controller}"
    expire_for(record)
  end

  def after_destroy(record)
    logger.info "Caught #{record.title rescue record.inspect}, with controller: #{controller}"
    expire_for(record, true)
  end

  def expire_for(record, destroying = false)
    case record
    when Page
      sweep_pages(record)
    when Content
      if record.invalidates_cache?(destroying)
        sweep_articles
        sweep_pages
      end
    when Sidebar, Category, Categorization
      sweep_articles
      sweep_pages
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

  def sweep_pages(record = nil)
    PageCache.sweep("/pages/#{record.name rescue ''}.html")
    expire_fragment(/.*\/pages\/.*/)
    expire_fragment(/.*\/view_page.*/)
  end

  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDERR)
  end
end
