class BlogSweeper < ActionController::Caching::Sweeper
  observe Category, Blog, Sidebar, User, Article, Page, Categorization

  def after_comments_create
    logger.debug 'BlogSweeper#after_comments_create'
    expire_for(controller.send(:instance_variable_get, :@comment))
  end

  alias_method :after_comments_update, :after_comments_create
  alias_method :after_articles_comment, :after_comments_create

  def after_comments_destroy
    logger.debug 'BlogSweeper#after_comments_destroy'
    expire_for(controller.send(:instance_variable_get, :@comment), true)
  end

  alias_method :after_articles_nuke_comment, :after_comments_destroy

  def after_articles_trackback
    logger.debug 'BlogSweeper#after_articles_trackback'
    expire_for(controller.send(:instance_variable_get, :@trackback))
  end

  def after_articles_nuke_trackback
    logger.debug 'BlogSweeper#after_articles_nuke_trackback'
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
      sweep_theme
    end
  end

  def sweep_all
    expire_fragment(/.*/)
    PageCache.sweep_all
  end

  def sweep_theme
    PageCache.sweep_theme_cache
  end

  def sweep_articles
    expire_fragment(%r{.*/articles/.*})
    unless Blog.default && Blog.default.cache_option == "caches_action_with_params"
      PageCache.zap_pages %w{index.* articles.* articles feedback
                             comments comments.* categories categories.* tags tags.* }
    end
  end

  def sweep_pages(record = nil)
    expire_fragment(/.*\/pages\/.*/)
    expire_fragment(/.*\/view_page.*/)
    unless Blog.default && Blog.default.cache_option == "caches_action_with_params"
      PageCache.zap_pages('pages')
    end
  end

  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDERR)
  end
end
