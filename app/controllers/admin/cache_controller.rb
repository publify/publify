require 'find'

class Admin::CacheController < Admin::BaseController
  def show
    @cache_size = 0
    @cache_number = 0

    FileUtils.mkdir_p(Publify::Application.config.action_controller.page_cache_directory) unless File.exist?(Publify::Application.config.action_controller.page_cache_directory)

    Find.find(Publify::Application.config.action_controller.page_cache_directory) do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == '.'
          Find.prune
        else
          next
        end
      else
        @cache_size += FileTest.size(path)
        @cache_number += 1
      end
    end
  end

  def destroy
    begin
      PageCache.sweep_all
      flash[:success] = t('admin.cache.destroy.success')
    rescue
      flash[:error] = t('admin.cache.destroy.error')
    end
    redirect_to action: :show
  end
end
