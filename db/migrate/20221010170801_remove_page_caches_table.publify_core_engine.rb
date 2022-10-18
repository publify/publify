# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20221010092846)
class RemovePageCachesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :page_caches
  end

  def down
    create_table :page_caches do |t|
      t.string :name
    end

    add_index :page_caches, :name
  end
end
