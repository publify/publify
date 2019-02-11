# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20190208151235)
class AddTextFilterNameFields < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :text_filter_name, :string
    add_column :feedback, :text_filter_name, :string
    add_column :users, :text_filter_name, :string
  end
end
