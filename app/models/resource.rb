require 'tempfile'

class Resource < ActiveRecord::Base
  validates_uniqueness_of :filename
  after_destroy :delete_filename_on_disk
  before_validation_on_create :uniq_filename_on_disk
  belongs_to :article

  #Reads YAML file from config dir (iTunes.yml) for easy updating
  def get_itunes_categories
      itunes_categories_raw = YAML::load( File.open( "#{RAILS_ROOT}/config/iTunes.yml" ) )
      itunes_categories = []
      itunes_categories_raw.keys.sort.each do |cat|
        itunes_categories.push cat => itunes_categories_raw[cat]
      end
      return itunes_categories
  end

  def validate_on_update
    if itunes_explicit?
      errors.add_to_base("You must check the box to activate metadata.") unless itunes_metadata?
      errors.add_to_base("You must specify an author.") if itunes_author.blank?
      errors.add_to_base("You must specify an subtitle.") if itunes_subtitle.blank?
      errors.add_to_base("You must specify a summary.") if itunes_summary.blank?
      errors.add_to_base("You must specify keywords.") if itunes_keywords.blank?
      if !itunes_duration.blank?
        errors.add_to_base("You must specify duration in a HH:MM:SS format.") unless itunes_duration =~ /^(\d{0,2}:)?\d{1,2}:?\d{2}$/
      end
      if !itunes_category.nil?
        errors.add_to_base("You can only specify one parent category, but you can choose multiple sub categories.") if itunes_category.length > 1
      end
    end
  end
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
