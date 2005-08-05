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
    flash['notice'] = 'Cache was cleared'
    redirect_to :controller => 'general'
  end
  
end
