class CampaignHeroImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  DISPLAY_WIDTH = 1440
  DISPLAY_HEIGHT = 488

  def store_dir
    "files/#{model.class.to_s.underscore}/#{model.id}/hero"
  end

  version :resized do
    process resize_to_fill: [DISPLAY_WIDTH, DISPLAY_HEIGHT]
  end
end
