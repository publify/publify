# This migration comes from publify_core_engine (originally 20170702105201)
class RemovePublishedAtFromFeedback < ActiveRecord::Migration[5.0]
  def change
    remove_column :feedback, :published_at, :datetime
  end
end
