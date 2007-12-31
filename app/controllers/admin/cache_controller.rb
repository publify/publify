class Admin::CacheController < Admin::BaseController

  def index
    list
    render :action => 'list'
  end

  def list
    @page_cache_size = -1
  end

  def sweep
    PageCache.sweep_all
    expire_fragment(/.*/)

    flash[:notice] = _('Cache was cleared')
    redirect_to :controller => '/admin/settings'
  end

  def sweep_html
    PageCache.sweep_all
    expire_fragment(/^contents_html.*/)

    flash[:notice] = _('HTML was cleared')
    redirect_to :controller => '/admin/settings'
  end

end
