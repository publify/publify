class AddCommentUserId < ActiveRecord::Migration
  class BareComment < ActiveRecord::Base
    include BareMigration
  end

  class BareUser <  ActiveRecord::Base
    include BareMigration
  end

  def self.up
    id_for_address = Hash[
      BareUser.find(:all).map {|u| [u.email, u.id] }
    ]

    modify_tables_and_update(:add_column, BareComment, :user_id, :integer) do |c|
      c.user_id = id_for_address[c.email]
    end
  end

  def self.down
    remove_column :comments, :user_id
  end
end
