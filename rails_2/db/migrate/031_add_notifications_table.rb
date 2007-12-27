class AddNotificationsTable < ActiveRecord::Migration
  def self.up
    create_table :notifications, :id => false do |t|
      t.column :notify_user_id, :integer
      t.column :notify_content_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :notifications
  end
end
