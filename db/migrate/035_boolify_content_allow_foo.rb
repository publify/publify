class Bare35Content < ActiveRecord::Base
  include BareMigration
end

class BoolifyContentAllowFoo < ActiveRecord::Migration
  def self.up
    say "Boolifying contents.allow_(comments|pings)"

    modify_tables_and_update([:rename_column, Bare35Content, :allow_pings,    :old_ap],
                             [:add_column,    Bare35Content, :allow_pings,    :boolean],
                             [:rename_column, Bare35Content, :allow_comments, :old_ac],
                             [:add_column,    Bare35Content, :allow_comments, :boolean]) do |c|
      unless $schema_generator
        c.allow_pings    = !c.old_ap.to_i.zero? ? true : false unless c.old_ap.nil?
        c.allow_comments = !c.old_ac.to_i.zero? ? true : false unless c.old_ac.nil?
      end
    end
    remove_column :contents, :old_ap
    remove_column :contents, :old_ac
  end

  def self.down
    say "Un-Boolifying contents.allow_(comments|pings)"
    modify_tables_and_update([:rename_column, Bare35Content, :allow_pings,    :old_ap],
                             [:add_column,    Bare35Content, :allow_pings,    :integer],
                             [:rename_column, Bare35Content, :allow_comments, :old_ac],
                             [:add_column,    Bare35Content, :allow_comments, :integer]) do |c|
      unless $schema_generator
        c.allow_pings    = c.old_ap ? 1 : 0 unless c.old_ap.nil?
        c.allow_comments = c.old_ac ? 1 : 0 unless c.old_ac.nil?
      end
    end
    remove_column :contents, :old_ap
    remove_column :contents, :old_ac
  end
end
