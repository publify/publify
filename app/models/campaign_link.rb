class CampaignLink < ActiveRecord::Base
  belongs_to :campaign

  validates :title, length: { maximum: 77 }
  validates :campaign_id, presence: true
end
