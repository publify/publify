class CreateTriggers < ActiveRecord::Migration
  def self.up
    create_table :triggers do |t|
      t.column :pending_item_id, :integer
      t.column :pending_item_type, :string
      t.column :due_at, :datetime
      t.column :trigger_method, :string
    end
  end

  def self.down
    drop_table :triggers
  end
end
