class PromoteCanonicalServerUrl < ActiveRecord::Migration
  def self.up
    add_column :blogs, :base_url, :string
    Blog.find(:all).each do |blog|
      blog.base_url = blog.canonical_server_url
      blog.save
    end
  end

  def self.down
    remove_column :blogs, :base_url
  end
end
