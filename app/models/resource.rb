require 'tempfile'
require 'mini_magick'
require 'yaml'

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

  def self.create_and_upload(file)
    resource = create(filename: file.original_filename, mime: file.content_type.chomp, created_at: Time.now)
    resource.upload(file)
  end

  def upload(file)
    storage = setup_storage
    directory = storage.directories.get('files')
    directory = storage.directories.create(:key => 'files') unless directory

    file = directory.files.create(
      :body => file,
      :key  => self.filename,
      :public => true
    )

    self.size = File.stat(fullpath).size rescue 0
    create_thumbnail
    update
    self
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

  private

  def setup_storage
    config = File.join(Rails.root, "config", "storage.yml")
    if File.exists? config
      @conf = YAML.load_file(config)
      provider = @conf['provider']
    else
      provider = "Local"
    end

    case provider
    when "AWS"
      return setup_aws_storage
    else
      return setup_local_storage
    end
  end

  def setup_local_storage
    # create the public/files dir if it doesn't exist
    FileUtils.mkdir(fullpath('')) unless File.directory?(fullpath(''))

    Fog::Storage.new({
      :local_root => File.join(Rails.root, "public"),
      :provider   => 'Local'
    })
  end

  def setup_aws_storage
    Fog::Storage.new({
      :provider   => 'AWS',
      :aws_access_key_id => @conf['aws_access_key_id'],
      :aws_secret_access_key => @conf['aws_secret_access_key']
    })
  end
end
