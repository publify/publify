class DropSessionTable < ActiveRecord::Migration
  def self.up
    drop_table :sessions
  end

  def self.down
    create_table :sessions do |t|
      t.column :sessid, :string
      t.column :data, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    add_index :sessions, :sessid
  end
end
