class Bare35Content < ActiveRecord::Base
  include BareMigration
end

class BoolifyContentAllowFoo < ActiveRecord::Migration
  def self.up
    STDERR.puts "Boolifying contents.allow_(comments|pings)"
    Bare35Content.transaction do
      rename_column :contents, :allow_pings, :old_ap
      add_column :contents, :allow_pings, :boolean
      rename_column :contents, :allow_comments, :old_ac
      add_column :contents, :allow_comments, :boolean

      unless $schema_generator
        Bare35Content.reset_column_information
        Bare35Content.find(:all, :conditions => "type = 'Article'").each do |c|
          c.allow_pings = !c.old_ap.to_i.zero? ? true : false unless c.old_ap.nil?
          c.allow_comments = !c.old_ac.to_i.zero? ? true : false unless c.old_ac.nil?
          c.save!
        end
      end
      remove_column :contents, :old_ap
      remove_column :contents, :old_ac
    end
  end

  def self.down
    STDERR.puts "Un-Boolifying contents.allow_(comments|pings)"
    Bare35Content.transaction do 
      rename_column :contents, :allow_pings, :old_ap
      add_column :contents, :allow_pings, :integer
      rename_column :contents, :allow_comments, :old_ac
      add_column :contents, :allow_comments, :integer

      unless $schema_generator
        Bare35Content.reset_column_information
        Bare35Content.find(:all, :conditions => "type = 'Article'").each do |c|
          c.allow_pings = c.old_ap ? 1 : 0 unless c.old_ap.nil?
          c.allow_comments = c.old_ac ? 1 : 0 unless c.old_ac.nil?
          c.save!
        end
      end
      remove_column :contents, :old_ap
      remove_column :contents, :old_ac
    end
  end
end
