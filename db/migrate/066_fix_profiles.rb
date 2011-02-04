class FixProfiles < ActiveRecord::Migration
  # We got this migration wrong before. Easiest fix is to undo it, then reapply
  # correctly

  class User < ActiveRecord::Base
    include BareMigration
  end

  class Profile < ActiveRecord::Base
  end

  def self.up
    remove_column :users, :profile_id
    add_column :users, :profile_id, :integer
    admin_id = Profile.find_by_label('admin').id
    User.update_all("profile_id = #{admin_id}")
  end

  def self.down
    remove_column :users, :profile_id
    add_column :users, :profile_id, :integer, :default => 1
  end
end
