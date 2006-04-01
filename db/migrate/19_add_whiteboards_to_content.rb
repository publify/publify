class AddWhiteboardsToContent < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding whiteboard to articles, comments and pages"
    modify_tables_and_update([:add_column, :articles, :whiteboard, :text],
                             [:add_column, :comments, :whiteboard, :text],
                             [:add_column, :pages,    :whiteboard, :text])
  end

  def self.down
    STDERR.puts "Removing whiteboard from articles, comments and pages"
    remove_column :articles, :whiteboard
    remove_column :comments, :whiteboard
    remove_column :pages, :whiteboard
  end
end
