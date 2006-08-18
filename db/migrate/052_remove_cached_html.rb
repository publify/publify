class RemoveCachedHtml < ActiveRecord::Migration
  def self.up
    remove_column :contents, :body_html
    remove_column :contents, :extended_html
  end

  def self.down
    add_column :contents, :body_html, :text
    add_column :contents, :extended_html, :text
  end
end
