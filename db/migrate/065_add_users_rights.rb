class AddUsersRights < ActiveRecord::Migration
  class Right < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  class ProfilesToRight < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  class Profile < ActiveRecord::Base
  end

  def self.up
    say "Creating users rights"
    create_table :rights, :force => true do |t|
      t.column :name, :string
      t.column :description, :string
    end

    create_table :profiles_to_rights, :force => true do |t|
      t.column :profile_id, :int
      t.column :right_id, :int
    end

    Right.transaction do
      admin = Profile.find_by_label('admin')
      publisher = Profile.find_by_label('publisher')
      contributor = Profile.find_by_label('contributor')

      # Global admin rights
      right = Right.create(:name => 'admin', :description => 'Global administration')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)

      # Article rights
      right = Right.create(:name => 'content_create', :description => 'Create article')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'content_edit', :description => 'Edit article')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'content_delete', :description => 'Delete article')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Categories rights
      right = Right.create(:name => 'category_create', :description => 'Create a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'category_edit', :description => 'Edit a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'category_delete', :description => 'Delete a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Page rights
      right = Right.create(:name => 'page_create', :description => 'Create a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'page_edit', :description => 'Edit a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'page_delete', :description => 'Delete a category')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)

      # Feedback
      right = Right.create(:name => 'feedback_create', :description => 'Add a comment')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_self_edit', :description => 'Edit self comments')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_edit', :description => 'Edit any comment')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_self_delete', :description => 'Delete self comments')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_delete', :description => 'Delete any comment')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)

      # Users
      right = Right.create(:name => 'user_create', :description => 'Create users')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.create(:name => 'user_edit', :description => 'Edit users')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.create(:name => 'user_self_edit', :description => 'Edit self account')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => publisher.id, :right_id => right.id)
      ProfilesToRight.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'user_delete', :description => 'Delete users')
      ProfilesToRight.create(:profile_id => admin.id, :right_id => right.id)
    end
  end

  def self.down
    drop_table :rights
    drop_table :profiles_to_rights
  end
end


