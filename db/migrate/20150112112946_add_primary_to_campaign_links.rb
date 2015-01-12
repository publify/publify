class AddPrimaryToCampaignLinks < ActiveRecord::Migration
  def change
     add_column :campaign_links, :primary, :boolean
  end
end
