class FixGrants < ActiveRecord::Migration
  class Right < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  class ProfilesRight < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  def self.up
    STDERR.puts "Creating users rights"
    drop_table :profiles_to_rights

    create_table :profiles_rights, :force => true do |t|
      t.column :profile_id, :int
      t.column :right_id, :int
    end

    Right.transaction do
      admin = Profile.find_by_label('admin')
      publisher = Profile.find_by_label('publisher')
      contributor = Profile.find_by_label('contributor')

      # Global admin rights
      right = Right.find_by_name('admin')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)

      # Article rights
      right = Right.find_by_name('content_create')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('content_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('content_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Categories rights
      right = Right.find_by_name('category_create')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('category_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('category_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Page rights
      right = Right.find_by_name('page_create')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('page_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.find_by_name('page_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Feedback
      right = Right.find_by_name('feedback_create')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.find_by_name('feedback_self_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.find_by_name('feedback_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.find_by_name('feedback_self_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.find_by_name('feedback_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)

      # Users
      right = Right.find_by_name('user_create')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.find_by_name('user_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.find_by_name('user_self_edit')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.find_by_name('user_delete')
      ProfilesRight.create(:profile_id => admin.id, :right_id => right.id)
    end
  end

  def self.down
    drop_table :rights
    drop_table :profiles_rights
  end
end


