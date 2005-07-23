require 'application'

class AddSidebars < ActiveRecord::Migration
  def self.up
    create_table :sidebars do |t|
      t.column :controller, :string
      t.column :active_position, :integer
      t.column :active_config, :text
      t.column :staged_position, :integer
      t.column :staged_config, :text
    end
    
    Sidebar.create(:active_position=>0, :controller=>'category')
    Sidebar.create(:active_position=>1, :controller=>'static')
    Sidebar.create(:active_position=>2, :controller=>'xml')
  end

  def self.down
    drop_table :sidebars
  end
end
