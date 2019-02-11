# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20170605071626)
class RemoveExtraStateColumnsFromFeedback < ActiveRecord::Migration[5.0]
  def change
    remove_column :feedback, :published, :boolean, default: false
    remove_column :feedback, :status_confirmed, :boolean
  end
end
