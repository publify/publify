class Campaign < ActiveRecord::Base

  has_one :primary_link, class_name: "CampaignLink", primary_key: 'primary_link_id', dependent: :destroy, foreign_key: 'id'
  has_one :secondary_link, class_name: "CampaignLink", primary_key: 'secondary_link_id', dependent: :destroy, foreign_key: 'id'
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
