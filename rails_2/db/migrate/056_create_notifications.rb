class CreateNotifications < ActiveRecord::Migration
  class OldNotification < ActiveRecord::Base
  end

  class Notification < ActiveRecord::Base
  end

  def self.up
    rename_table :notifications, :old_notifications

    create_table :notifications do |t|
      t.column :content_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    OldNotification.reset_column_information
    Notification.reset_column_information
    if $schema_generator
      OldNotification.find(:all).each do |on|
        Notification.create!(on.attributes)
      end
    end
    drop_table :old_notifications
  end

  def self.down
    remove_column :notifications, :id
    rename_column :notifications, :user_id, :notify_user_id
    rename_column :notifications, :content_id, :notify_content_id
  end
end
