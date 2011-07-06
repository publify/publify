class Bare25Resource < ActiveRecord::Base
  include BareMigration
end

class AddItunesMetadata < ActiveRecord::Migration
  def self.up
    say "Adding podcast metadata fields"
    modify_tables_and_update([:add_column, :resources, :itunes_metadata, :boolean],
                             [:add_column, :resources, :itunes_author, :string],
                             [:add_column, :resources, :itunes_subtitle, :string],
                             [:add_column, :resources, :itunes_duration, :integer],
                             [:add_column, :resources, :itunes_summary, :text],
                             [:add_column, :resources, :itunes_keywords, :string],
                             [:add_column, :resources, :itunes_category, :string],
                             [:add_column, :resources, :itunes_explicit, :boolean])
  end

  def self.down
    say "Removing podcast metadata fields"
    modify_tables_and_update([:remove_column, :resources, :itunes_metadata, :boolean],
                             [:remove_column, :resources, :itunes_author, :string],
                             [:remove_column, :resources, :itunes_subtitle, :string],
                             [:remove_column, :resources, :itunes_duration, :integer],
                             [:remove_column, :resources, :itunes_summary, :text],
                             [:remove_column, :resources, :itunes_keywords, :string],
                             [:remove_column, :resources, :itunes_category, :string],
                             [:remove_column, :resources, :itunes_explicit, :boolean])
  end
end
