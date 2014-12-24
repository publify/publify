class Campaign < ActiveRecord::Base

  has_one :primary_link, class_name: "CampaignLink"
  has_one :secondary_link, class_name: "CampaignLink"
  accepts_nested_attributes_for :primary_link
  accepts_nested_attributes_for :secondary_link

  mount_uploader :hero_image, CampaignHeroImageUploader

  validates :title, presence: true, length: { maximum: 29 }
  validates :description, presence: true, length: { maximum: 187 }

  before_save :disable_other_campaigns

  scope :lead, -> { where(active: true) }

  def disable_other_campaigns
    Campaign.where.not(id: self.id).update_all(active: false)
  end
end
