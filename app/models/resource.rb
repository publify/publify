require 'tempfile'
require 'mini_magick'

class Resource < ActiveRecord::Base
  validates_uniqueness_of :filename
  after_destroy :delete_filename_on_disk
  before_validation :uniq_filename_on_disk, :on => :create

  belongs_to :article

  scope :without_images, where("mime NOT LIKE '%image%'")
  scope :images, where("mime LIKE '%image%'")
  scope :by_filename, order("filename")
  scope :by_created_at, order("created_at DESC")

  scope :without_images_by_filename, without_images.by_filename
  scope :images_by_created_at, images.by_created_at

  def fullpath(file = nil)
    "#{::Rails.root.to_s}/public/files/#{file.nil? ? filename : file}"
  end

  def write_to_disk(up)
    begin
      # create the public/files dir if it doesn't exist
      FileUtils.mkdir(fullpath('')) unless File.directory?(fullpath(''))
      if up.kind_of?(Tempfile) and !up.local_path.nil? and File.exist?(up.local_path)
        File.chmod(0600, up.local_path)
        FileUtils.copy(up.local_path, fullpath)
      elsif up.kind_of?(ActionDispatch::Http::UploadedFile)
        File.chmod(0600, up.path)
        FileUtils.copy(up.path, fullpath)
      else
        bytes = up
        if up.kind_of?(StringIO)
          up.rewind
          bytes = up.read
        end
        File.open(fullpath, "wb") { |f| f.write(bytes) }
      end
      File.chmod(0644, fullpath)
      self.size = File.stat(fullpath).size rescue 0
      create_thumbnail
      update
      self
    rescue
      raise
    end
  end

  def create_thumbnail
    blog = Blog.default
    return unless self.mime =~ /image/
    return unless File.exists?(fullpath("#{self.filename}"))
    begin
      img_orig = MiniMagick::Image.from_file(fullpath(self.filename))

      ['medium', 'thumb'].each do |size|
        next if File.exists?(fullpath("#{size}_#{self.filename}"))
        resize = blog.send("image_#{size.to_s}_size").to_s
        img_orig = img_orig.resize("#{resize}x#{resize}")
        img_orig.write(fullpath("#{size}_#{self.filename}"))
      end
   rescue
      nil
  end
  end

  protected
  def uniq_filename_on_disk
    i = 0
    raise if filename.empty?
    tmpfile = File.basename(filename.gsub(/\\/, '/')).gsub(/[^\w\.\-]/,'_')
    filename = tmpfile
    while File.exist?(fullpath(tmpfile))
      i += 1
      tmpfile = filename.sub(/^(.*?)(\.[^\.]+)?$/, '\1'+"#{i}"+'\2')
    end
    self.filename = tmpfile
  end
  def delete_filename_on_disk
    File.unlink(fullpath(filename)) if File.exist?(fullpath(filename))
  end
end
