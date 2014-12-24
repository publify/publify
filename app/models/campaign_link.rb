class CampaignLink < ActiveRecord::Base
  belongs_to :campaign

  validates :title, length: { maximum: 77 }
end
