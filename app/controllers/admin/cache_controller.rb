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
    redirect_to :action => 'list'
  end
  
end
