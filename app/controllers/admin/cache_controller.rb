require 'find'

class Admin::CacheController < Admin::BaseController
  def show
    @cache_size = 0
    @cache_number = 0
  end

  def destroy
    begin
      PageCache.sweep_all
      flash[:success] = t('admin.cache.destroy.success')
    rescue
      flash[:error] = t('admin.cache.destroy.error')
    end
    redirect_to admin_cache_url
  end
end
