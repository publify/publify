class Cache < ActiveRecord::Base
  validates_uniqueness_of :page_name
  after_destroy :expire_cache

  def self.sweep(pattern)
    destroy_all("page_name like '#{pattern}'")
  end

  def self.sweep_all
    destroy_all
  end

  private
  def expire_cache
    # It'd be better to call expire_page here, except it's a
    # controller method and we can't get to it.
    path = "public/"+self.page_name
    File.delete(path) if File.file?(path) 
  end
end
