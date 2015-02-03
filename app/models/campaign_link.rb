class CampaignLink < ActiveRecord::Base
  belongs_to :campaign

  LINK_TYPE_OPTIONS = ["ma says", "article", "external"]

  validates :title, length: { maximum: 77 }
end
