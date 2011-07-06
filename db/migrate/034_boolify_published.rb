class Bare34Content < ActiveRecord::Base
  include BareMigration
end

class BoolifyPublished < ActiveRecord::Migration
  def self.up
    say "Boolifying contents.published"
    modify_tables_and_update([:rename_column, Bare34Content, :published, :old_pub],
                             [:add_column,    Bare34Content, :published, :boolean, { :default => true }]) do |c|
      unless $schema_generator
        if c.old_pub.nil?
          c.published = true
        else
          c.published = (!c.old_pub.to_i.zero? ? true : false)
        end
      end
    end
    remove_column :contents, :old_pub
  end

  def self.down
    say "Un-Boolifying contents.published"
    modify_tables_and_update([:rename_column, Bare34Content, :published, :old_pub],
                             [:add_column,    Bare34Content, :published, :integer]) do |c|
      unless $schema_generator
        say "Old published: #{c.old_pub}"
        if c.old_pub.nil?
          c.published = 1
        else
          c.published = c.old_pub ? 1 : 0
        end
      end
    end
    remove_column :contents, :old_pub
  end
end
