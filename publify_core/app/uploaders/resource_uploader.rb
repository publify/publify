require 'carrierwave'

class ResourceUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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
    new_file.content_type && new_file.content_type.include?('image')
  end
end
