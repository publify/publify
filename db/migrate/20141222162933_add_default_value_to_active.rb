class AddDefaultValueToActive < ActiveRecord::Migration
  def change
    change_column :campaigns, :active, :boolean, :default => false
  end
end
