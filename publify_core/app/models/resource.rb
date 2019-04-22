# frozen_string_literal: true

require "carrierwave"
require "carrierwave/orm/activerecord"

class Resource < ApplicationRecord
  belongs_to :blog
  belongs_to :content, optional: true

  mount_uploader :upload, ResourceUploader
  validates :upload, presence: true
end
