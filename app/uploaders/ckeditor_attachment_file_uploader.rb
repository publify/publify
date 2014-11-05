class CkeditorAttachmentFileUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave

  def store_dir
    "attachments/#{model.id}"
  end

  def extension_white_list
    Ckeditor.attachment_file_types
  end
end
