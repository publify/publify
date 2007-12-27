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

    def remove(pending_item, conditions = { })
      return if pending_item.new_record?
      conditions_string =
        conditions.keys.collect{ |k| "(#{k} = :#{k})"}.join(' AND ')
      with_scope(:find => { :conditions => [conditions_string, conditions]}) do
        delete_all(["pending_item_id = ? AND pending_item_type = ?",
                    pending_item.id, pending_item.class.to_s])
      end
    end
  end

  def before_destroy
    returning true do
      pending_item.send(trigger_method) if pending_item
    end
  end
end
