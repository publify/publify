# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20160108111120)
class AddDeviseToUsers < ActiveRecord::Migration[4.2]
  def self.up
    ## Database authenticatable
    change_column :users, :email, :string, null: false, default: ""
    rename_column :users, :password, :encrypted_password
    change_column :users, :encrypted_password, :string, null: false, default: ""

    change_table(:users) do |t|
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Timestamps were not included in our original model.
      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :reset_password_token

    remove_column :users, :created_at
    remove_column :users, :updated_at

    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip

    remove_column :users, :remember_created_at

    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at

    change_column :users, :encrypted_password, :string, null: true, default: nil
    rename_column :users, :encrypted_password, :password
    change_column :users, :email, :text, null: true, default: nil
  end
end
