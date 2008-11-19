class MoveEditorToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :editor, :integer, :default => 2
    
    unless $schema_generator
      blog = Blog.default
      editor = blog.editor
      users = User.find(:all)
      users.each do |user|
        user.editor = editor.to_i
        user.save!
      end
    end
    
  end

  def self.down
    remove_column :users, :editor
  end
end
