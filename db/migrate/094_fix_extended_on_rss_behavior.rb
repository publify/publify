class FixExtendedOnRssBehavior < ActiveRecord::Migration
  def self.up
    unless Blog.default.nil?
      Blog.default.hide_extended_on_rss = true unless Blog.default.show_extended_on_rss
      Blog.default.save!
    end
  end

  def self.down
    blog = Blog.first
    Blog.default.show_extended_on_rss = true unless Blog.default.hide_extended_on_rss
    Blog.default.save!
  end
end
