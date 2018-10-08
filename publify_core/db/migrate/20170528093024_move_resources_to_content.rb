# frozen_string_literal: true

class MoveResourcesToContent < ActiveRecord::Migration[5.0]
  def change
    rename_column :resources, :article_id, :content_id
  end
end
