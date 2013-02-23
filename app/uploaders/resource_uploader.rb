class ResourceUploader < CarrierWave::Uploader::Base

  # To handle Base64 uploads...
  class FilelessIO < StringIO
    attr_accessor :original_filename

    def initialize(data, filename)
      super(data)
      @original_filename = filename
    end
  end

  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  process :set_content_type

  def store_dir
    "files/#{model.class.to_s.underscore}/#{model.id}"
  end

  version :thumb, :if => :image? do
    process :dynamic_resize_to_fit => :thumb
  end

  version :medium, :if => :image? do
    process :dynamic_resize_to_fit => :medium
  end

  def dynamic_resize_to_fit(size)
    blog = Blog.default
    resize_setting = blog.send("image_#{size}_size").to_i

    resize_to_fit(resize_setting, resize_setting)
  end

  def image?(new_file)
    new_file.content_type && new_file.content_type.include?('image')
  end
end
