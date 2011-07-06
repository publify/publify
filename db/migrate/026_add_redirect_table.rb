class AddRedirectTable < ActiveRecord::Migration
  def self.up
    say "Adding Redirect Table"
    create_table :redirects do |t|
      t.column :from_path, :string
      t.column :to_path, :string
    end
  end

  def self.down
    drop_table :redirects
  end
end
