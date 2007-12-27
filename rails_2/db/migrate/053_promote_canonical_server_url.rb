class PromoteCanonicalServerUrl < ActiveRecord::Migration
  class Blog < ActiveRecord::Base
    include BareMigration
    serialize :settings, Hash
  end

  def self.up
    add_column :blogs, :base_url, :string
    Blog.find(:all).each do |blog|
      begin
        blog.base_url = blog.settings['canonical_server_url']
        blog.save
      rescue
        # if base_url doesn't exist, then we don't really care.
      end
    end
  end

  def self.down
    remove_column :blogs, :base_url
  end
end
