class AddContentStateField < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    modify_tables_and_update(:add_column, Content,
                             :state, :text) do |content|
      unless $schema_generator
        if content.published?
          content.state = 'Published'
        elsif content.published_at
          content.state = 'PublicationPending'
        else
          content.state = 'Draft'
        end
      end
    end
  end

  def self.down
    remove_column :contents, :state
  end
end
