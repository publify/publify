class Trigger < ApplicationRecord
  belongs_to :pending_item, polymorphic: true

  class << self
    def post_action(due_at, item, method = 'came_due')
      create!(due_at: due_at, pending_item: item,
              trigger_method: method)
      fire
    end

    def fire
      where('due_at <= ?', Time.zone.now).destroy_all
      true
    end

    def remove(pending_item, conditions = {})
      return if pending_item.new_record?
      conditions = conditions.merge(pending_item_id: pending_item.id,
                                    pending_item_type: pending_item.class.to_s)
      where(conditions).delete_all
    end
  end

  # TODO: Ensure errors bubble up to where they are visible
  before_destroy :trigger_pending_item

  def trigger_pending_item
    pending_item.send(trigger_method) if pending_item
    true
  end
end
