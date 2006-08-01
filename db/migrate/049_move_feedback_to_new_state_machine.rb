class MoveFeedbackToNewStateMachine < ActiveRecord::Migration
  class Content < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    return if $schema_generator
    Content.find(:all,
                 :conditions => ['type = ? or type = ?',
                                    'Trackback', 'Comment']).each do |c|
      c.state = if c.published?
                  'ContentState::PresumedHam'
                else
                  'ContentState::PresumedSpam'
                end
      c.save!
    end
  end

  def self.down
    return if $schema_generator
    Content.find(:all,
                 :conditions => ['type = ? or type = ?',
                                    'Trackback', 'Comment']).each do |c|
      c.state = if c.published?
                  'ContentState::Published'
                else
                  'ContentState::Withdrawn'
                end
      c.save!
    end
  end
end
