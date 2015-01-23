class AddFullBleedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :full_bleed, :boolean
  end
end
