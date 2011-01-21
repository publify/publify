class Redirect < ActiveRecord::Base
  validates_uniqueness_of :from_path
  validates_presence_of :from_path
  validates_presence_of :to_path

  def full_to_path
    path = self.to_path
    url_root = this_blog.root_path
    path = url_root + path unless url_root.nil? or path[0,url_root.length] == url_root
    path
  end
end
