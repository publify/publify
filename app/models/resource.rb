class Resource < ActiveRecord::Base
  belongs_to :article

  mount_uploader :upload, ResourceUploader

  scope :without_images, lambda { where("mime NOT LIKE '%image%'") }
  scope :images, lambda { where("mime LIKE '%image%'") }
  scope :by_filename, lambda { order("upload") }
  scope :by_created_at, lambda { order("created_at DESC") }

  scope :without_images_by_filename, lambda { without_images.by_filename }
  scope :images_by_created_at, lambda { images.by_created_at }
end
