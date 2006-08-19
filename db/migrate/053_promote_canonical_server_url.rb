class PromoteCanonicalServerUrl < ActiveRecord::Migration
  class Blog < ActiveRecord::Base
    include BareMigration
    serialize :settings, Hash
  end

  def self.up
    add_column :blogs, :base_url, :string
    Blog.find(:all).each do |blog|
      blog.base_url = blog.settings['canonical_server_url']
      blog.save
    end
  end

  def self.down
    remove_column :blogs, :base_url
  end
end
