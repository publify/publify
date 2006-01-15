require 'set'

class PageCache < ActiveRecord::Base
  has_and_belongs_to_many :contributors, :class_name => 'Content'
  
  cattr_accessor :public_path
  @@public_path = ActionController::Base.page_cache_directory

  def self.sweep(pattern)
    self.destroy_and_list(pattern)
  end

  def self.sweep_all
    self.destroy_and_list(:all)
  end

  def self.destroy_and_list(pattern)
    conditions = if pattern == :all
                   nil
                 else
                   ['name like ?', pattern]
                 end
    self.find(:all, :conditions => conditions).collect do |i|
      i.destroy
      i.name
    end
  end
      

  private

#  after_destroy :expire_cache
  
  def expire_cache
    # It'd be better to call expire_page here, except it's a
    # controller method and we can't get to it.

    logger.info "Sweeping #{self.name}"
    delete_page(self.name)
  end

  def delete_page(page)
    delete_file(join('/', public_path, page))
  end
  
  def delete_file(path)
    File.delete(path) if File.file?(path)     
  end
end
