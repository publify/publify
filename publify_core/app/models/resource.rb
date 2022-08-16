# frozen_string_literal: true

require "carrierwave"
require "carrierwave/orm/activerecord"

class Resource < ApplicationRecord
  include StringLengthLimit
  belongs_to :blog
  belongs_to :content, optional: true

  mount_uploader :upload, ResourceUploader
  validates :upload, presence: true

  validates_default_string_length :mime
end
