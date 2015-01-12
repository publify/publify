class AddIndexToCampaignLinks < ActiveRecord::Migration
  def change
    add_index :campaign_links, :primary
  end
end
