# frozen_string_literal: true

require "marcel"

class ResourceUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  before :cache, :check_content_type!

  def content_type_allowlist
    [%r{image/}, %r{audio/}, %r{video/}, "text/plain"]
  end

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

  def check_content_type!(new_file)
    detected_type = if image? new_file
                      file_content_content_type(new_file)
                    else
                      file_content_type(new_file)
                    end
    if detected_type != new_file.content_type
      raise CarrierWave::IntegrityError, "has MIME type mismatch"
    end
  end

  private

  def file_content_content_type(new_file)
    Marcel::MimeType.for Pathname.new(new_file.path)
  end

  def file_content_type(new_file)
    Marcel::MimeType.for Pathname.new(new_file.path), name: new_file.filename
  end
end
