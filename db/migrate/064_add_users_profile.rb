class Bare64Profile < ActiveRecord::Base
  include BareMigration

  # there's technically no need for these serialize declaration because in
  # this script active_config and staged_config will always be NULL anyway.
  serialize :active_config
  serialize :staged_config
end

class AddUsersProfile < ActiveRecord::Migration
  def self.up
    STDERR.puts "Creating users profiles"
    Bare64Profile.transaction do
      create_table :profiles do |t|
        t.column :label, :string
        t.column :nicename, :string
      end

      Bare64Profile.create(:label => 'admin', :nicename => 'Typo administrator')
      Bare64Profile.create(:label => 'publisher', :nicename => 'Blog publisher')
      Bare64Profile.create(:label => 'contributor', :nicename => 'Contributor')

      add_column("users", "profile_id", :integer, :default => 1)
    end
  end

  def self.down
    drop_table :profiles
  end
end


