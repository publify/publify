class AddPrimaryAndSecondaryIds < ActiveRecord::Migration
  def change
    add_column :campaigns, :primary_link_id, :integer
    add_column :campaigns, :secondary_link_id, :integer
  end
end
