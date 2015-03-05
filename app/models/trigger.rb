class Trigger < ActiveRecord::Base
  belongs_to :pending_item, polymorphic: true

  class << self
    def post_action(due_at, item, method = 'came_due')
      create!(due_at: due_at, pending_item: item,
              trigger_method: method)
      fire
    end

    def fire
      destroy_all ['due_at <= ?', Time.now]
      true
    rescue
      migrator = Migrator.new

      unless migrator.pending_migrations.empty?
        starting_version = migrator.current_schema_version
        migrator.migrate

        if starting_version == 0
          load "#{Rails.root}/Rakefile"
          Rake::Task['db:seed'].invoke
          User.reset_column_information
          Article.reset_column_information
          Page.reset_column_information
        end
      end
    end

    def remove(pending_item, conditions = {})
      return if pending_item.new_record?
      conditions = conditions.merge(pending_item_id: pending_item.id,
                                    pending_item_type: pending_item.class.to_s)
      where(conditions).delete_all
    end
  end

  before_destroy :trigger_pending_item

  def trigger_pending_item
    pending_item.send(trigger_method) if pending_item
    true
  end
end
