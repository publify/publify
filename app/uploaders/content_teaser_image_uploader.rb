class ContentTeaserImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  DISPLAY_WIDTH = 576
  DISPLAY_HEIGHT = 288

  def store_dir
    "files/#{model.class.to_s.underscore}/#{model.id}/teaser"
  end

  version :resized do
    process resize_to_fill: [DISPLAY_WIDTH, DISPLAY_HEIGHT]
  end
end
