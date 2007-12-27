class AddPublishedAtToContent < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update(:add_column, Content,
                             :published_at, :datetime) do |content|
      unless $schema_generator
        content.published_at = content.created_at
      end
    end
  end

  def self.down
    remove_column :contents, :published_at
  end
end
