class MoveEditorAsString < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    remove_column :users, :editor
    add_column :users, :editor, :string, :default => 'simple'

    unless $schema_generator
      User.update_all("editor = 'simple'")
    end

  end

  def self.down
    remove_column :users, :editor
    add_column :users, :editor, :integer, :default => 0
  end
end
