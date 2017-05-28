# This migration comes from publify_core_engine (originally 20170528094923)
class MoveTagsToContent < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles_tags, :article_id, :content_id
    rename_table :articles_tags, :contents_tags
  end
end
