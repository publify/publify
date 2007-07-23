class AddUsersRights < ActiveRecord::Migration
  class Right < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  class Profiles_to_right < ActiveRecord::Base
    include BareMigration

    # there's technically no need for these serialize declaration because in
    # this script active_config and staged_config will always be NULL anyway.
    serialize :active_config
    serialize :staged_config
  end

  def self.up
    STDERR.puts "Creating users rights"
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
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)

      # Article rights
      right = Right.create(:name => 'content_create', :description => 'Create article')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'content_edit', :description => 'Edit article')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'content_delete', :description => 'Delete article')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)

      # Categories rights
      right = Right.create(:name => 'category_create', :description => 'Create a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'category_edit', :description => 'Edit a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'category_delete', :description => 'Delete a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)

      # Page rights
      right = Right.create(:name => 'page_create', :description => 'Create a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'page_edit', :description => 'Edit a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      right = Right.create(:name => 'page_delete', :description => 'Delete a category')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      
      # Feedback
      right = Right.create(:name => 'feedback_create', :description => 'Add a comment')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_self_edit', :description => 'Edit self comments')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_edit', :description => 'Edit any comment')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_self_delete', :description => 'Delete self comments')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'feedback_delete', :description => 'Delete any comment')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      
      # Users
      right = Right.create(:name => 'user_create', :description => 'Create users')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.create(:name => 'user_edit', :description => 'Edit users')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      right = Right.create(:name => 'user_self_edit', :description => 'Edit self account')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => publisher.id, :right_id => right.id)
      Profiles_to_right.create(:profile_id => contributor.id, :right_id => right.id)
      right = Right.create(:name => 'user_delete', :description => 'Delete users')
      Profiles_to_right.create(:profile_id => admin.id, :right_id => right.id)
    end
  end

  def self.down
    drop_table :rights
  end
end


