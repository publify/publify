# desc "Explaining what the task does"
# task :fckeditor do
#   # Task goes here
# end

namespace :fckeditor do
  def setup 
    require "config/environment"
    require 'fileutils'
    
    directory = File.join(RAILS_ROOT, '/vendor/plugins/fckeditor/')
    require "#{directory}lib/fckeditor"
    require "#{directory}lib/fckeditor_version"
    require "#{directory}lib/fckeditor_file_utils"
  end
  
  desc 'Install the FCKEditor components'
  task :install do
    setup
    puts "** Installing FCKEditor Plugin version #{FckeditorVersion.current}..."           

    FckeditorFileUtils.destroy_and_install 
         
    puts "** Successfully installed FCKEditor Plugin version #{FckeditorVersion.current}"
  end
  
  def fetch(path)
    response = Net::HTTP.get_response(URI.parse(path))
    case response
    when Net::HTTPSuccess     then 
      response
    when Net::HTTPRedirection then 
      puts "** Redirected to #{response['location']}"
      fetch(response['location'])
    else
      response.error!
    end
  end
  
  desc "Update the FCKEditor code to the latest nightly build"    
  task :download do
    require 'net/http'
    require 'zip/zipfilesystem'

    setup
    version = ENV['VERSION'] || "Nightly"
    installed_version = "2.6"

    puts "** Current FCKEditor version: #{installed_version}..."   
    puts "** Downloading #{version} (1.2mb - please be patient)..."

    rails_tmp_path = File.join(RAILS_ROOT, "/tmp/")
    tmp_zip_path = File.join(rails_tmp_path, "fckeditor_#{version}.zip")
    
    # Creating tmp dir if it doesn't exist
    Dir.mkdir(rails_tmp_path) unless File.exists? rails_tmp_path    

    # Download nightly build (http://www.fckeditor.net/nightly/FCKeditor_N.zip)
    # Releases (http://downloads.sourgefourge.net/fckeditor/FCKEditor_[2.4.3, 2.5b, 2.4.2].zip)    
    nightly = version=='Nightly' ? true : false
    domain = nightly ? "http://www.fckeditor.net" : "http://downloads.sourceforge.net"
    path = nightly ? "/nightly/FCKeditor_N.zip" : "/fckeditor/FCKeditor_#{version}.zip"
    
    puts "** Download from #{domain}#{path}"
    #Net::HTTP.start(domain) { |http|
      response = fetch("#{domain}#{path}")
      
      open(tmp_zip_path, "wb") { |file|
        file.write(response.body)
      }
    #}
    puts "** Download successful"
    
    puts "** Extracting FCKeditor"
    Zip::ZipFile.open(tmp_zip_path) do |zipfile|
      zipfile.each do |entry|
        filename = File.join(rails_tmp_path, entry.name)
        FileUtils.rm_f(filename)
        FileUtils.mkdir_p(File.dirname(filename))
        entry.extract(filename)
      end
    end
    
    puts "** Backing up existing FCKEditor install to /public/javascripts/fckeditor_bck"
    FckeditorFileUtils.backup_existing

    puts "** Shifting files to /public/javascripts/fckeditor"
    FileUtils.cp_r File.join(RAILS_ROOT, "/tmp/fckeditor/"), File.join(RAILS_ROOT, "/public/javascripts/")
    
    puts "** Clean up"
    FileUtils.remove_file(tmp_zip_path, true)
    FileUtils.remove_entry(File.join(rails_tmp_path, "fckeditor/"), true)
    
    puts "** Successfully updated to FCKEditor version: #{version}..."  
  end
end

