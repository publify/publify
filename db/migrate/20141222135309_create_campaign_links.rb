class CreateCampaignLinks < ActiveRecord::Migration
  def change
    create_table :campaign_links do |t|
      t.string :title
      t.string :url
      t.string :type
      t.references :campaign, index: true

      t.timestamps
    end
  end
end
