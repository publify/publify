# This migration comes from publify_core_engine (originally 20150810094754)
class AddBlogIdToTags < ActiveRecord::Migration
  class Tag < ActiveRecord::Base; end

  def up
    add_column :tags, :blog_id, :integer
    if Tag.any?
      default_blog_id = Blog.order(:id).first.id
      Tag.update_all("blog_id = #{default_blog_id}")
    end
  end

  def down
    remove_column :tags, :blog_id
  end
end
