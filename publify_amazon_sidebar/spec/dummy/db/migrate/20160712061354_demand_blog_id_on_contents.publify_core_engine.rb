# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20160701061851)
class DemandBlogIdOnContents < ActiveRecord::Migration[4.2]
  def up
    change_column :contents, :blog_id, :integer, null: false
  end

  def down
    change_column :contents, :blog_id, :integer, null: true
  end
end
