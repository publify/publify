class CacheInformation < ActiveRecord::Base
  validates_presence_of :path
  validates_uniqueness_of :path

  before_destroy :delete_path_in_page_cache_directory

  def delete_path_in_page_cache_directory
    if File.exist? path_in_page_cache_directory
      FileUtils.rm(path_in_page_cache_directory)
    else
      Rails.logger.warn("path : #{path} no more exist")
    end
  end

  def path_in_page_cache_directory
    File.join(ActionController::Base.page_cache_directory, path)
  end

end
