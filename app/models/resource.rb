class Resource < ActiveRecord::Base
  belongs_to :article

  mount_uploader :upload, ResourceUploader

  scope :without_images, -> { where("mime NOT LIKE '%image%'") }
  scope :images, -> { where("mime LIKE '%image%'") }
  scope :by_filename, -> { order('upload') }
  scope :by_created_at, -> { order('created_at DESC') }

  scope :without_images_by_filename, -> { without_images.by_filename }
  scope :images_by_created_at, -> { images.by_created_at }
end
