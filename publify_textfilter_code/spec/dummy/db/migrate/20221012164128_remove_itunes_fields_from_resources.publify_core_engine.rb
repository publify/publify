# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20221012163214)
class RemoveItunesFieldsFromResources < ActiveRecord::Migration[6.1]
  def change
    remove_column :resources, :itunes_metadata, :boolean
    remove_column :resources, :itunes_author, :string
    remove_column :resources, :itunes_subtitle, :string
    remove_column :resources, :itunes_duration, :integer
    remove_column :resources, :itunes_summary, :text
    remove_column :resources, :itunes_keywords, :string
    remove_column :resources, :itunes_category, :string
    remove_column :resources, :itunes_explicit, :boolean
  end
end
