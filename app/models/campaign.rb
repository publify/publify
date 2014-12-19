class Campaign < ActiveRecord::Base

  has_one :primary_link, class_name: "CampaignLink"
  has_one :secondary_link, class_name: "CampaignLink"

  validates :title, presence: true, length: { maximum: 29 }
  validates :description, presence: true, length: { maximum: 187 }

  before_save :disable_other_campaigns

  private

  def disable_other_campaigns
    Campaign.where.not(id: self.id).update_all(active: false)
  end
end
