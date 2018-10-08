# frozen_string_literal: true

class MoveTagsToContent < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles_tags, :article_id, :content_id
    rename_table :articles_tags, :contents_tags
  end
end
