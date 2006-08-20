class LinkSidebarsToBlog < ActiveRecord::Migration
  class Sidebar < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update(:add_column, Sidebar, :blog_id, :integer) do |sb|
      next if $schema_generator
      sb.blog_id = 1
      sb.save!
    end
  end

  def self.down
    remove_column :sidebars, :blog_id
  end
end
