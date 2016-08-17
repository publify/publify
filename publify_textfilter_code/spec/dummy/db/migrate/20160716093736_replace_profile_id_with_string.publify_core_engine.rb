# This migration comes from publify_core_engine (originally 20160605103918)
class ReplaceProfileIdWithString < ActiveRecord::Migration
  class Profile < ActiveRecord::Base

  end
  class User < ActiveRecord::Base

  end

  def up
    add_column :users, :profile, :string

    User.reset_column_information
    User.find_each do |user|
      user.update_attribute(:profile, Profile.find(user.profile_id).label)
    end

    remove_column :users, :profile_id
  end

  def down
    add_column :users, :profile_id, :integer

    User.reset_column_information
    User.find_each do |user|
      user.update_attribute(:profile_id, Profile.find_by(label: user.profile).id)
    end

    remove_column :users, :profile
  end
end
