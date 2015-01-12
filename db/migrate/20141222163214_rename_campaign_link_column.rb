class RenameCampaignLinkColumn < ActiveRecord::Migration
  def change
    rename_column :campaign_links, :type, :link_type
  end
end
