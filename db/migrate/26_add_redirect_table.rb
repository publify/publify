class AddRedirectTable < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding Redirect Table"
    Content.transaction do
      create_table :redirects do |t|
        t.column :from_path, :string
        t.column :to_path, :string
      end
    end
  end

  def self.down
  end
end
