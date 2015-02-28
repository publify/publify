class BlogSweeper < ActionController::Caching::Sweeper
  observe Blog, User, Article, Page, Comment, Trackback, Note, Tag

  def pending_sweeps
    @pending_sweeps ||= Set.new
  end

  def run_pending_page_sweeps
    pending_sweeps.each do |each|
      send(each)
    end
  end

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
    expire_for(record) unless record.is_a?(Article) && record.state == :draft
  end

  def after_destroy(record)
    expire_for(record, true)
  end

  # TODO: Simplify this. Almost every sweep amounts to a sweep_all.
  def expire_for(record, destroying = false)
    case record
    when Page
      pending_sweeps << :sweep_pages
    when Content
      if record.invalidates_cache?(destroying)
        pending_sweeps << :sweep_articles << :sweep_pages
      end
    when Tag
      pending_sweeps << :sweep_articles << :sweep_pages
    when Blog, User, Comment, Trackback
      pending_sweeps << :sweep_all << :sweep_theme
    end
    run_pending_page_sweeps unless controller
  end

  def sweep_all
    PageCache.sweep_all
  end

  def sweep_theme
    PageCache.sweep_theme_cache
  end

  def sweep_articles
    PageCache.sweep_all
  end

  def sweep_pages
    PageCache.zap_pages(%w(pages)) unless Blog.default.nil?
  end

  def logger
    @logger ||= ::Rails.logger || Logger.new(STDERR)
  end

  private

  def callback(timing)
    super
    run_pending_page_sweeps if timing == :after
  end
end
