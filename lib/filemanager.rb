=begin
  filemanager.rb
  Copyright (C) 2008  Leon Li

  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end
require 'uri'
require 'fileutils'
FM_ID = 'filemanager'
FM_ROOT = File.join(::Rails.root.to_s, 'vendor', 'plugins', FM_ID)
FM_PATH_PUBLIC = File.join(FM_ROOT, 'public')

=begin
if $FM_OVERWRITE || ! File.exist?(FM_ROOT)
fm_rails_path = File.dirname(File.dirname(__FILE__)) + "/#{FM_ID}"
FileUtils.cp_r(fm_rails_path, File.join(::Rails.root.to_s, 'vendor', 'plugins'))
FileUtils.cp_r(FM_PATH_PUBLIC, ::Rails.root.to_s)
FileUtils.rm_rf(FM_PATH_PUBLIC)
end
=end

FM_CONFIG_FILE = File.join(::Rails.root.to_s, 'config', 'filemanager.yml')
unless File.exist?(FM_CONFIG_FILE)
  FileUtils.cp(File.join(FM_ROOT, 'filemanager.yml'))
end
require "erb"
require "yaml"
$FM_PROPERTIES = YAML::load(ERB.new(IO.read(FM_CONFIG_FILE)).result)

FM_IMAGE_TYPES   = $FM_PROPERTIES['image.type'].split(' ')
FM_FLASH_TYPES   = $FM_PROPERTIES['flash.type'].split(' ')
FM_MOVIE_TYPES   = $FM_PROPERTIES['movie.type'].split(' ')
FM_RM_TYPES      = $FM_PROPERTIES['rm.type'].split(' ')
FM_OFFICE_TYPES  = $FM_PROPERTIES['office.type'].split(' ')
FM_EXCEL_TYPES   = $FM_PROPERTIES['excel.type'].split(' ')
FM_WORD_TYPES    = $FM_PROPERTIES['word.type'].split(' ')
FM_PPT_TYPES     = $FM_PROPERTIES['ppt.type'].split(' ')
FM_HELP_TYPES    = $FM_PROPERTIES['help.type'].split(' ')
FM_PLAIN_TYPES  = $FM_PROPERTIES['plain.type'].split(' ')
FM_NONE_TYPES    = $FM_PROPERTIES['none.type'].split(' ')
FM_SUPPORT_TYPES = FM_IMAGE_TYPES + FM_FLASH_TYPES + FM_MOVIE_TYPES + FM_RM_TYPES + FM_OFFICE_TYPES + FM_HELP_TYPES + FM_PLAIN_TYPES
FM_UNKNOWN_TYPE = 'unknown'

FM_RESOURCES_PATH= $FM_PROPERTIES['resources.path']
FM_LOCK_PATH     = $FM_PROPERTIES['resources.url']
FM_ENCODING_TO   = $FM_PROPERTIES['encoding.to']
FM_ENCODING_FROM = $FM_PROPERTIES['encoding.from'].nil? ? '' : $FM_PROPERTIES['encoding.from']

FM_TEMP_DIR      = $FM_PROPERTIES['temp.dir'].nil? ? File.join(FM_ROOT, 'temp') : $FM_PROPERTIES['temp.dir']

FileUtils.rm_rf(Dir.glob("#{FM_TEMP_DIR}/*"))

