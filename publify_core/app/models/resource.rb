require 'carrierwave'
require 'carrierwave/orm/activerecord'

class Resource < ActiveRecord::Base
  belongs_to :blog
  belongs_to :article, optional: true

  mount_uploader :upload, ResourceUploader
  validate :image_mime_type_consistent
  validates :upload, presence: true

  private

  def image_mime_type_consistent
    if upload.content_type =~ %r{^image/}
      expected_type = upload.file.content_type
      errors.add(:upload, 'Has MIME type mismatch') unless upload.content_type == expected_type
    end
  end
end
