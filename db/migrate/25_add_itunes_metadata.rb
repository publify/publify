class AddItunesMetadata < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding podcast metadata fields"
    Resource.transaction do
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
  end
end
