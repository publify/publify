class Bare4Sidebar < ActiveRecord::Base
  include BareMigration

  # there's technically no need for these serialize declaration because in
  # this script active_config and staged_config will always be NULL anyway.
  serialize :active_config
  serialize :staged_config
end

class AddSidebars < ActiveRecord::Migration
  def self.up
    STDERR.puts "Creating sidebars"
    Bare4Sidebar.transaction do
      create_table :sidebars do |t|
        t.column :controller, :string
        t.column :active_position, :integer
        t.column :active_config, :text
        t.column :staged_position, :integer
        t.column :staged_config, :text
      end
      
      Bare4Sidebar.create(:active_position=>0, :controller=>'category')
      Bare4Sidebar.create(:active_position=>1, :controller=>'static')
      Bare4Sidebar.create(:active_position=>2, :controller=>'xml')
    end
  end

  def self.down
    drop_table :sidebars
  end
end
