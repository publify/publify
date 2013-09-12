class AddsUserAvatar < ActiveRecord::Migration
  def up
    say "Adds user avatar"
    add_column :users, :resource_id, :integer
  end

  def down
    say "Adds user avatar"
    remove_column :users, :resource_id
  end
end
