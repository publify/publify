class AddsFeedbackUseragent < ActiveRecord::Migration
  def up
    add_column :feedback, :user_agent, :string
  end

  def down
    remove_column :feedback, :user_agent
  end
end
