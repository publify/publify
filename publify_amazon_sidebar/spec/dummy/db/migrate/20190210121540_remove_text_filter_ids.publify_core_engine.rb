# This migration comes from publify_core_engine (originally 20190209155717)
class RemoveTextFilterIds < ActiveRecord::Migration[5.2]
  def up
    remove_column :contents, :text_filter_id
    remove_column :feedback, :text_filter_id
    remove_column :users, :text_filter_id
  end

  def down
    add_column :contents, :text_filter_id, :integer
    add_column :feedback, :text_filter_id, :integer
    add_column :users, :text_filter_id, :string, default: '1'

    add_index :contents, [:text_filter_id]
    add_index :feedback, [:text_filter_id]
    add_index :users, [:text_filter_id]
  end
end
