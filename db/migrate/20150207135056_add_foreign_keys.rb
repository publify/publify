class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :tags, :articles_tags
    add_foreign_key :contents, :articles_tags
    add_foreign_key :text_filters, :contents
    add_foreign_key :users, :contents
    add_foreign_key :contents, :feedback
    add_foreign_key :text_filters, :feedback
    add_foreign_key :users, :feedback
    add_foreign_key :contents, :pings
    add_foreign_key :contents, :redirections
    add_foreign_key :redirects, :redirections
    add_foreign_key :contents, :resources
    add_foreign_key :profiles, :users
    add_foreign_key :resources, :users
    add_foreign_key :text_filters, :users
 end
end
