class AddStateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :default => 'active'
    
    unless $schema_generator
      users = User.find(:all)
      users.each do |user|
        user.state = 'active'
        user.save!
      end
    end
    
  end

  def self.down
    remove_column :users, :state
  end
end
