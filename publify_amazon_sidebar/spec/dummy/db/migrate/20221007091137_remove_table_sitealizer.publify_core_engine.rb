# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20221007091049)
class RemoveTableSitealizer < ActiveRecord::Migration[6.1]
  def up
    drop_table :sitealizer
  end

  def down
    create_table :sitealizer do |t|
      t.string :path
      t.string :ip
      t.string :referer
      t.string :language
      t.string :user_agent
      t.datetime :created_at
      t.date :created_on
    end
  end
end
