class RemoveNotificationsTable < ActiveRecord::Migration
  def self.up
    drop_table :notifications
  end

  def self.down
    create_table :notifications do |t|
      t.column :content_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end
