require 'bare_migration'
class FixupForthcomingPublications < ActiveRecord::Migration
  class Trigger < ActiveRecord::Base
    belongs_to :pending_item, :polymorphic => true
  end

  class Content < ActiveRecord::Base
  end

  class Article < Content
  end

  def self.up
    return if $schema_generator
    Article.transaction do
      Trigger.transaction do
        Article.find(:all, :conditions => ['published = ? AND published_at > ?',
                                           true, Time.now]).each do |art|
          Trigger.create!(:pending_item   => art,
                          :due_at         => art.published_at,
                          :trigger_method => 'publish!')
          art.update_attribute(:published, false)
        end
      end
    end
  end

  def self.down
    return if $schema_generator
    Article.transaction do
      Trigger.transaction do
        Trigger.find(:all,
                     :conditions => "pending_item_type = 'Article' AND trigger_method = 'publish!'").each do |t|
          t.pending_item.update_attribute(:published, :true)
          t.destroy
        end
      end
    end
  end
end
