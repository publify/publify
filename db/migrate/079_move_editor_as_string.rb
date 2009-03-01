class MoveEditorAsString < ActiveRecord::Migration
  def self.up
    remove_column :users, :editor
    add_column :users, :editor, :string, :default => 'simple'
    
    unless $schema_generator
      users = User.find(:all)
      users.each do |user|
        user.editor = 'simple'
        user.save!
      end
    end
    
  end

  def self.down
    remove_column :users, :editor
    add_column :users, :editor, :integer, :default => 0
  end
end
