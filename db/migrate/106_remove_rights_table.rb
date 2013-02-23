class RemoveRightsTable < ActiveRecord::Migration
  def self.up
    drop_table :rights
  end

  def self.down
    create_table rights do |t|
      t.column :name, :string
      t.column :description, :string
    end
  end
end
