# frozen_string_literal: true

class RemovePublishedAtFromFeedback < ActiveRecord::Migration[5.0]
  def change
    remove_column :feedback, :published_at, :datetime
  end
end
