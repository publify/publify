class Bare34Content < ActiveRecord::Base
  include BareMigration
end

class BoolifyPublished < ActiveRecord::Migration
  def self.up
    STDERR.puts "Boolifying contents.published"
    Bare34Content.transaction do
      rename_column :contents, :published, :old_pub
      add_column :contents, :published, :boolean, :default => true

      unless $schema_generator
        Bare34Content.reset_column_information
        Bare34Content.find(:all).each do |c|
          unless c.old_pub.nil?
            c.published = (!c.old_pub.to_i.zero? ? true : false) 
            c.save!
          end
        end
      end
      remove_column :contents, :old_pub
    end
  end

  def self.down
    STDERR.puts "Un-Boolifying contents.published"
    Bare34Content.transaction do
      rename_column :contents, :published, :old_pub
      add_column :contents, :published, :integer

      unless $schema_generator
        Bare34Content.reset_column_information
        Bare34Content.find(:all).each do |c|
          unless c.old_pub.nil?
            c.published = c.old_pub ? 1 : 0
            c.save!
          end
        end
      end
      remove_column :contents, :old_pub
    end
  end
end
