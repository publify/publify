class AddUsersProfile < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  def self.up
    say "Creating users profiles"
    create_table :profiles do |t|
      t.column :label, :string
      t.column :nicename, :string
      add_column(:users, :profile_id, :integer, :default => 1)
    end

    Profile.transaction do
      admin = Profile.create(:label => 'admin', :nicename => 'Typo administrator')
      Profile.create(:label => 'publisher', :nicename => 'Blog publisher')
      Profile.create(:label => 'contributor', :nicename => 'Contributor')
    end
  end

  def self.down
    drop_table :profiles
    remove_column :users, :profile_id
  end
end


