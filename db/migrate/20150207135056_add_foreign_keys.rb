class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :articles_tags, :tags
    add_foreign_key :articles_tags, :contents, column: :article_id
    add_foreign_key :contents, :text_filters
    add_foreign_key :contents, :users
    add_foreign_key :feedback, :contents, column: :article_id
    add_foreign_key :feedback, :text_filters
    add_foreign_key :feedback, :users
    add_foreign_key :pings, :contents, column: :article_id
    add_foreign_key :redirections, :contents
    add_foreign_key :redirections, :redirects
    add_foreign_key :resources, :contents, column: :article_id
    add_foreign_key :users, :profiles
    add_foreign_key :users, :resources
 end
end
