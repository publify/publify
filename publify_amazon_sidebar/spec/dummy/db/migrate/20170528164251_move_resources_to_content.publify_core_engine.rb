# This migration comes from publify_core_engine (originally 20170528093024)
class MoveResourcesToContent < ActiveRecord::Migration[5.0]
  def change
    rename_column :resources, :article_id, :content_id
  end
end
