# Install hook code here

directory = File.join(RAILS_ROOT, '/vendor/plugins/fckeditor/')
require "#{directory}lib/fckeditor_file_utils"
require "#{directory}lib/fckeditor_version"
require "#{directory}lib/fckeditor"

puts "** Installing FCKEditor Plugin version #{FckeditorVersion.current}...." 

FckeditorFileUtils.destroy_and_install

puts "** Successfully installed FCKEditor Plugin version #{FckeditorVersion.current}"