class AddJabberNotification < ActiveRecord::Migration
  def self.up
    User.transaction do
      add_column :users, :notify_via_jabber, :boolean
      add_column :users, :jabber, :string
    end
  end

  def self.down
    remove_column :users, :notify_via_jabber
    remove_column :users, :jabber
  end
end
