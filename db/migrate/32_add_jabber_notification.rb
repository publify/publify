class AddJabberNotification < ActiveRecord::Migration
  def self.up
    User.transaction do
      add_column :users, :notify_via_jabber, :boolean
      add_column :users, :jabber, :string
    end
  end

  def self.down
  end
end
