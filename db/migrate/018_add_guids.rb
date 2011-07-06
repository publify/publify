class AddGuids < ActiveRecord::Migration
  def self.up
    say "Adding GUIDs to Comments and Trackbacks"

    modify_tables_and_update([:add_column, :comments,   :guid, :string],
                             [:add_column, :trackbacks, :guid, :string])
  end

  def self.down
    remove_column :comments, :guid
    remove_column :trackbacks, :guid
  end
end
