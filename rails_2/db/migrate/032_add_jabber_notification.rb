class AddJabberNotification < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_via_jabber, :boolean
    add_column :users, :jabber, :string
  end

  def self.down
    remove_column :users, :notify_via_jabber
    remove_column :users, :jabber
  end
end
