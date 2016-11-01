class Resource < ActiveRecord::Base
  belongs_to :blog
  belongs_to :article

  mount_uploader :upload, ResourceUploader
  validate :image_mime_type_consistent
  validates :upload, presence: true

  scope :without_images, -> { where("mime NOT LIKE '%image%'") }
  scope :images, -> { where("mime LIKE '%image%'") }
  scope :by_filename, -> { order('upload') }
  scope :by_created_at, -> { order('created_at DESC') }

  scope :without_images_by_filename, -> { without_images.by_filename }
  scope :images_by_created_at, -> { images.by_created_at }

  private

  def image_mime_type_consistent
    if upload.content_type =~ %r{^image/}
      expected_type = upload.file.send :mime_magic_content_type
      errors.add(:upload, 'Has MIME type mismatch') unless upload.content_type == expected_type
    end
  end
end
