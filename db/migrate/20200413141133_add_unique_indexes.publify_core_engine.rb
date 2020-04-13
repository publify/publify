# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20200413140440)

class AddUniqueIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :post_types, :name, unique: true
    add_index :redirects, :from_path, unique: true
    add_index :tags, [:blog_id, :name], unique: true
    add_index :users, :login, unique: true
  end
end
