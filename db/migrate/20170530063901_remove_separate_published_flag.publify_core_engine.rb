# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20170528201606)
class RemoveSeparatePublishedFlag < ActiveRecord::Migration[5.0]
  def change
    remove_column :contents, :published, :boolean, default: false
  end
end
