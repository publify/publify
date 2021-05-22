# frozen_string_literal: true

require "marcel"

class ResourceUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  before :cache, :check_image_content_type!

  def store_dir
    "files/#{model.class.to_s.underscore}/#{model.id}"
  end

  version :thumb, if: :image? do
    process dynamic_resize_to_fit: :thumb
  end

  version :medium, if: :image? do
    process dynamic_resize_to_fit: :medium
  end

  version :avatar, if: :image? do
    process dynamic_resize_to_fit: :avatar
  end

  def dynamic_resize_to_fit(size)
    resize_setting = model.blog.send("image_#{size}_size").to_i

    resize_to_fit(resize_setting, resize_setting)
  end

  def image?(new_file)
    content_type = new_file.content_type
    content_type&.include?("image")
  end

  def check_image_content_type!(new_file)
    if image?(new_file)
      magic_type = mime_magic_content_type(new_file)
      if magic_type != new_file.content_type
        raise CarrierWave::IntegrityError, "has MIME type mismatch"
      end
    end
  end

  private

  # NOTE: This method was adapted from MagicMimeBlacklist#extract_content_type
  # from CarrierWave 1.0.0 and SanitizedFile#mime_magic_content_type from CarrierWave 0.11.2
  def mime_magic_content_type(new_file)
    content_type = nil

    File.open(new_file.path) do |fd|
      content_type = Marcel::MimeType.for(fd)
    end

    content_type
  end
end
