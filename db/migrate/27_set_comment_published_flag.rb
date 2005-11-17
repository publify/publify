class SetCommentPublishedFlag < ActiveRecord::Migration
  def self.up
    STDERR.puts "Setting published flag on each comment"
    Comment.find(:all).each do |c|
      c.published = true
      c.save
    end
  end

  def self.down
  end
end
