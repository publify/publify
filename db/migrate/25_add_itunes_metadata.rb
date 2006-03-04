class Bare25Resource < ActiveRecord::Base
  include BareMigration
end

class AddItunesMetadata < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding podcast metadata fields"
    Bare25Resource.transaction do
      add_column :resources, :itunes_metadata, :boolean
      add_column :resources, :itunes_author, :string
      add_column :resources, :itunes_subtitle, :string
      add_column :resources, :itunes_duration, :integer
      add_column :resources, :itunes_summary, :text
      add_column :resources, :itunes_keywords, :string
      add_column :resources, :itunes_category, :string
      add_column :resources, :itunes_explicit, :boolean
    end
  end

  def self.down
    STDERR.puts "Removing podcast metadata fields"
    Bare25Resource.transaction do
      remove_column :resources, :itunes_metadata
      remove_column :resources, :itunes_author
      remove_column :resources, :itunes_subtitle
      remove_column :resources, :itunes_duration
      remove_column :resources, :itunes_summary
      remove_column :resources, :itunes_keywords
      remove_column :resources, :itunes_category
      remove_column :resources, :itunes_explicit
    end
  end
end
