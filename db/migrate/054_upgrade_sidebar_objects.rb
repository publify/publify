class UpgradeSidebarObjects < ActiveRecord::Migration
  class Sidebar < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update(:add_column, Sidebar, :type, :string) do |sb|
      next if $schema_generator
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
