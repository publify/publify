class RemoveSidebarStagedConfig < ActiveRecord::Migration
  class BareSidebar < ActiveRecord::Base
    include BareMigration
    serialize :active_config
    serialize :staged_config
  end


  def self.up
    remove_column :sidebars, :staged_config
    rename_column :sidebars, :active_config, :config
  end

  def self.down
    modify_tables_and_update([:rename_column, BareSidebar, :config, :active_config],
                             [:add_column,    BareSidebar, :staged_config, :text]) do |sb|
      unless $schema_generator
        sb.staged_config = sb.active_config
      end
    end
  end
end
