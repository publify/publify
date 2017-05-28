require 'carrierwave'
require 'carrierwave/orm/activerecord'

class Resource < ActiveRecord::Base
  belongs_to :blog
  belongs_to :article, optional: true

  mount_uploader :upload, ResourceUploader
  validates :upload, presence: true
end
