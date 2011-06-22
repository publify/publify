class FixNofollowOptionsBehavior < ActiveRecord::Migration
  def self.up
    unless Blog.default.nil?
      Blog.default.unindex_categories = false if Blog.default.index_categories
      Blog.default.unindex_tags = false if Blog.default.index_tags
      Blog.default.dofollowify = true unless Blog.default.nofollowify
      Blog.default.save!
    end
  end

  def self.down
    blog = Blog.first
    Blog.default.index_categories = true unless Blog.default.unindex_categories
    Blog.default.index_tags = true unless Blog.default.unindex_tags
    Blog.default.dofollowify = true unless Blog.default.nofollowify
    Blog.default.save!
  end
end
