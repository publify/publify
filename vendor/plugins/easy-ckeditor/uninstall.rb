directory = File.join(RAILS_ROOT, '/vendor/plugins/easy-ckeditor/')
require "#{directory}lib/ckeditor_file_utils"
require "#{directory}lib/ckeditor_version"
require "#{directory}lib/ckeditor"

puts "** Uninstalling Easy CKEditor Plugin version #{CkeditorVersion.current}...."

CkeditorFileUtils.destroy
