require 'fileutils'

module CkeditorFileUtils
  CKEDITOR_INSTALL_DIRECTORY = File.join(::Rails.root.to_s, '/public/javascripts/ckeditor/')
  PLUGIN_INSTALL_DIRECTORY =  File.join(::Rails.root.to_s, '/vendor/plugins/easy-ckeditor/')

  def CkeditorFileUtils.recursive_copy(options)
    source = options[:source]
    dest = options[:dest]
    logging = options[:logging].nil? ? true : options[:logging]

    Dir.foreach(source) do |entry|
      next if entry =~ /^\./
      if File.directory?(File.join(source, entry))
        unless File.exist?(File.join(dest, entry))
          if logging
            puts "Creating directory #{entry}..."
          end
          FileUtils.mkdir File.join(dest, entry)#, :noop => true#, :verbose => true
        end
        recursive_copy(:source => File.join(source, entry),
                       :dest => File.join(dest, entry),
                       :logging => logging)
      else
        if logging
          puts "  Installing file #{entry}..."
        end
        FileUtils.cp File.join(source, entry), File.join(dest, entry)#, :noop => true#, :verbose => true
      end
    end
  end

  def CkeditorFileUtils.backup_existing
    source = File.join(::Rails.root.to_s,'/public/javascripts/ckeditor')
    dest = File.join(::Rails.root.to_s,'/public/javascripts/ckeditor_bck')

    FileUtils.rm_r(dest) if File.exists? dest
    FileUtils.mv source, dest
  end

  def CkeditorFileUtils.copy_configuration
    # need to copy over the code if it doesn't already exist
    config_file = File.join(::Rails.root.to_s, '/vendor/plugins/easy-ckeditor/public/javascripts/ckcustom.js')
    dest = File.join(::Rails.root.to_s, '/public/javascripts/ckcustom.js')
    backup_config = File.join(::Rails.root.to_s, '/public/javascripts/ckeditor/config.bak')
    config_symlink = File.join(::Rails.root.to_s, '/public/javascripts/ckeditor/config.js')
    FileUtils.cp(config_file, dest) unless File.exist?(dest)
    if File.exist?(config_symlink)
      unless File.symlink?(config_symlink)
        FileUtils.rm(backup_config) if File.exist?(backup_config)
        FileUtils.mv(config_symlink,backup_config)
        FileUtils.cp(dest, config_symlink)
      end
    else
      FileUtils.cp(dest, config_symlink)
    end
  end

  def CkeditorFileUtils.create_uploads_directory
    uploads = File.join(::Rails.root.to_s, '/public/uploads')
    FileUtils.mkdir(uploads) unless File.exist?(uploads)
  end

  def CkeditorFileUtils.install(log)
    directory = File.join(::Rails.root.to_s, '/vendor/plugins/easy-ckeditor/')
    source = File.join(directory,'/public/javascripts/ckeditor/')
    FileUtils.mkdir(CKEDITOR_INSTALL_DIRECTORY)
    # recursively copy all our files over
    recursive_copy(:source => source, :dest => CKEDITOR_INSTALL_DIRECTORY, :logging => log)
    # create the upload directories
    create_uploads_directory
  end

  ##################################################################
  # remove the existing install (if any)
  #
  def  CkeditorFileUtils.destroy
    if File.exist?(CKEDITOR_INSTALL_DIRECTORY)
      FileUtils.rm_r(CKEDITOR_INSTALL_DIRECTORY)

      FileUtils.rm(File.join(::Rails.root.to_s, '/public/javascripts/ckcustom.js')) \
      if File.exist? File.join(::Rails.root.to_s, '/public/javascripts/ckcustom.js')
    end
  end

  def CkeditorFileUtils.rm_plugin
    if File.exist?(PLUGIN_INSTALL_DIRECTORY)
      FileUtils.rm_r(PLUGIN_INSTALL_DIRECTORY)
    end
  end

  def CkeditorFileUtils.destroy_and_install
    CkeditorFileUtils.destroy
    # now install fresh
    install(true)
    # copy over the config file (unless it exists)
    copy_configuration
  end

  def CkeditorFileUtils.check_and_install
    # check to see if already installed, if not install
    unless File.exist?(CKEDITOR_INSTALL_DIRECTORY)
      install(false)
    end
    # copy over the config file (unless it exists)
    copy_configuration
  end
end
