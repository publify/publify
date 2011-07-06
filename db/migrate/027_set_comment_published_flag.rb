class Bare27Content < ActiveRecord::Base
  include BareMigration
  # See #24 for a description of how we have to manually handle STI
end

class SetCommentPublishedFlag < ActiveRecord::Migration
  def self.up
    say "Setting published flag on each comment"
    Bare27Content.transaction do
      Bare27Content.find(:all, :conditions => "type = 'Comment'").each do |c|
        c.published = true
        c.save!
      end
    end
  end

  def self.down
  end
end
