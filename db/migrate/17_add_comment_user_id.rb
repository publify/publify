class Bare17Comment < ActiveRecord::Base
  include BareMigration
end

class Bare17User <  ActiveRecord::Base
  include BareMigration
end

class AddCommentUserId < ActiveRecord::Migration
  def self.up
    users = Hash.new

    Bare17Comment.transaction do
      add_column :comments, :user_id, :integer

      Bare17Comment.reset_column_information
      Bare17Comment.find(:all).each do |c|
        userid = nil
        if users[c.email]
          c.user_id = users[c.email]
          c.save!
        elsif user = Bare17User.find_by_email(c.email)
          c.user_id = user.id
          users[c.email] = user.id
          c.save!
        end
      end
    end
  end

  def self.down
    remove_column :comments, :user_id
  end
end
