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

    flash[:notice] = 'Cache was cleared'
    redirect_to :controller => '/admin/general'
  end

  def sweep_html
    expire_fragment(/^contents_html.*/)

    flash[:notice] = 'HTML was cleared'
    redirect_to :controller => '/admin/general'
  end

end
