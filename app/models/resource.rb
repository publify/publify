require 'tempfile'
require 'mini_magick'

class Resource < ActiveRecord::Base
  validates_uniqueness_of :filename
  after_destroy :delete_filename_on_disk
  before_validation_on_create :uniq_filename_on_disk
  belongs_to :article
  
  def fullpath(file = nil)
    "#{RAILS_ROOT}/public/files/#{file.nil? ? filename : file}"
  end

  def write_to_disk(up)
    begin
      # create the public/files dir if it doesn't exist
      FileUtils.mkdir(fullpath('')) unless File.directory?(fullpath(''))
      if up.kind_of?(Tempfile) and !up.local_path.nil? and File.exist?(up.local_path)
        File.chmod(0600, up.local_path)
        FileUtils.copy(up.local_path, fullpath)
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
      update
      self
    rescue
      raise
    end
  end

  def create_thumbnail
    return unless self.mime =~ /image/ or File.exists?(fullpath("thumb_#{self.filename}"))
    return unless File.exists?(fullpath("#{self.filename}"))
    begin
      img_orig = MiniMagick::Image.from_file(fullpath(self.filename))
      img_orig = img_orig.resize('125x125')
      img_orig.write(fullpath("thumb_#{self.filename}"))
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
