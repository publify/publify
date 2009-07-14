class AddStateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :default => 'active'
    
    unless $schema_generator
      User.update_all("state = 'active'")
    end
    
  end

  def self.down
    remove_column :users, :state
  end
end
