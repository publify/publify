class Trigger < ActiveRecord::Base
  belongs_to :pending_item, :polymorphic => true

  class << self
    def post_action(due_at, item, method='came_due')
      create!(:due_at => due_at, :pending_item => item,
              :trigger_method => method)
      fire
    end

    def fire
      destroy_all ['due_at <= ?', Time.now]
      true
    end
  end

  def before_destroy
    pending_item.send(trigger_method)
    true
  end
end
