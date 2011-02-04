class MoveEditorToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    add_column :users, :editor, :integer, :default => 2
    User.update_all("editor = #{Blog.default.editor.to_i}")
  end

  def self.down
    remove_column :users, :editor
  end
end
