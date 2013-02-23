require 'find'

class Admin::CacheController < Admin::BaseController
  def index
    @cache_size = 0
    @cache_number = 0

    FileUtils.mkdir_p(TypoBlog::Application.config.action_controller.page_cache_directory) unless File.exists?(TypoBlog::Application.config.action_controller.page_cache_directory)

    if request.post?
      begin
        PageCache.sweep_all
        flash.now[:notice] = _("Cache was successfully sweeped")
      rescue
        flash.now[:error] = _("Oops, something wrong happened. Cache could not be cleaned")
      end
    end

    Find.find(TypoBlog::Application.config.action_controller.page_cache_directory) do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?.
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

end
