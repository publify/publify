class AddGuids < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding GUIDs to Comments and Trackbacks"
    Comment.transaction do
      add_column :comments, :guid, :string
      add_column :trackbacks, :guid, :string
      
      Comment.find(:all).each do |c|
        c.save if c.guid.blank?
      end
      Trackback.find(:all).each do |t|
        t.save if t.guid.blank?
      end
    end
  end

  def self.down
    remove_column :comments, :guid
    remove_column :trackbacks, :guid
  end
end
