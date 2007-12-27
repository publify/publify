VERSION = '2.0.6.1'

namespace :tiny_mce do
  namespace :scripts do
    desc 'Install the TinyMCE scripts into the public/javascripts directory of this application'
    task :install do
      require 'fileutils'
      dest = RAILS_ROOT + '/public/javascripts/tiny_mce'
      if File.exists?(dest)
        puts "Error : destination directory #{dest} already exists, perhaps you need to update instead?"
        exit 1
      else
        puts "Creating directory #{dest}..."
        FileUtils.mkdir dest
        puts "** Installing TinyMCE version #{VERSION} to #{dest}..."
        recursively_copy File.expand_path(File.dirname(__FILE__) + '/../public/javascripts/tiny_mce'), dest
        puts "** Successfully installed TinyMCE version #{VERSION}"
      end
    end
    
    task :update do
      puts "Not yet implemented."
    end
  end
end

def recursively_copy(source, dest)
  Dir.chdir(source)
  Dir.foreach(source) do |entry|
    next if entry =~ /^\./
    if File.directory?(File.join(source, entry))
      puts "Creating directory #{entry}..."
      FileUtils.mkdir File.join(dest, entry)#, :noop => true#, :verbose => true
      recursively_copy File.join(source, entry), File.join(dest, entry)
    else
      puts "  Installing file #{entry}..."
      FileUtils.cp File.join(source, entry), File.join(dest, entry)#, :noop => true#, :verbose => true
    end
  end
end