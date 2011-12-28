class Trigger < ActiveRecord::Base
  belongs_to :pending_item, :polymorphic => true

  class << self
    def post_action(due_at, item, method='came_due')
      create!(:due_at => due_at, :pending_item => item,
              :trigger_method => method)
      fire
    end

    def fire
      begin
        destroy_all ['due_at <= ?', Time.now]
        true
      rescue
        @current_version = Migrator.current_schema_version
        @needed_version = Migrator.max_schema_version
        @support = Migrator.db_supports_migrations?
        @needed_migrations = Migrator.available_migrations[@current_version..@needed_version].collect do |mig|
          mig.scan(/\d+\_([\w_]+)\.rb$/).flatten.first.humanize
        end
        if @needed_migrations
          Migrator.migrate
        end
      end
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

  before_destroy :trigger_pending_item

  def trigger_pending_item
    pending_item.send(trigger_method) if pending_item
    return true
  end
end
