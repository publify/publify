class Admin::CacheController < Admin::BaseController
  
  def index
    list
    render_action 'list'
  end

  def list
    @page_cache_size = PageCache.count
  end

  def sweep
    PageCache.sweep_all
    expire_fragment(/.*/)
        
    flash['notice'] = 'Cache was cleared'
    redirect_to :controller => 'general'
  end
  
  def sweep_html
    Article.transaction do
      Article.update_all 'body_html = null'
      Comment.update_all 'body_html = null'
      Page.update_all 'body_html = null'
    end

    flash['notice'] = 'HTML was cleared'
    redirect_to :controller => 'general'
  end
  
end
