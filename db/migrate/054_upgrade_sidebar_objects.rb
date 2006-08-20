class UpgradeSidebarObjects < ActiveRecord::Migration
  class Sidebar < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update(:add_column, Sidebar, :type, :string) do |sb|
      next if $schema_generator
      if sb.controller.nil?
        raise "Found a sidebar, \"#{sb.id}\", which doesn't know its controller so can't convert it. Settings are:\n #{sb.settings}. Please either correct the controller or delete the sidebar."
      end
      sb.type = sb.controller.camelcase + 'Sidebar'
      sb.save!
    end
    remove_column :sidebars, :controller
  end

  def self.down
    modify_tables_and_update(:add_column, Sidebar, :controller, :string) do |sb|
      next if $schema_generator
      sb.controller = sb[:type].underscore.sub(/_sidebar$/, '')
      sb.save!
    end
    remove_column :sidebars, :type
  end
end
