# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20190209160610)
class RemoveTextFilters < ActiveRecord::Migration[5.2]
  def up
    drop_table :text_filters
  end

  def down
    create_table :text_filters do |t|
      t.string :name
      t.string :description
      t.string :markup
      t.text :filters
      t.text :params
    end
  end
end
