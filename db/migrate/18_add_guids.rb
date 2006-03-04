class Bare18Comment < ActiveRecord::Base
  include BareMigration
end

class AddGuids < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding GUIDs to Comments and Trackbacks"
    Bare18Comment.transaction do
      add_column :comments, :guid, :string
      add_column :trackbacks, :guid, :string

#     Bare18Comment.reset_column_information
#     Bare18Trackback.reset_column_information
      
# These blow up if you're running post-migration 20 code.
# We can safely ignore them, because they'll get fixed
# anyway when we convert comments and trackbacks into contents.

#      Comment.find(:all).each do |c|
#        c.save! if c.guid.blank?
#      end
#      Trackback.find(:all).each do |t|
#        t.save! if t.guid.blank?
#      end
    end
  end

  def self.down
    Bare18Comment.transaction do
      remove_column :comments, :guid
      remove_column :trackbacks, :guid
    end 
  end
end
