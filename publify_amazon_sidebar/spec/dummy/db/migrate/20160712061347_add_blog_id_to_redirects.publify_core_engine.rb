# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20150808191127)
class AddBlogIdToRedirects < ActiveRecord::Migration[4.2]
  class Redirect < ActiveRecord::Base; end

  def up
    add_column :redirects, :blog_id, :integer
    if Redirect.any?
      default_blog_id = Blog.order(:id).first.id
      Redirect.update_all("blog_id = #{default_blog_id}")
    end
  end

  def down
    remove_column :redirects, :blog_id
  end
end
