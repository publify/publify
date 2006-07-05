require 'installer/rails-installer'

class TypoInstaller < RailsInstaller
  application_name 'typo'
  support_location 'the Typo mailing list'
  rails_version '1.1.4'
  
  def install_sequence
    stop
    
    backup_database
    pre_migrate_database
    copy_files
    freeze_rails
    create_default_config_files
    create_directories
    create_initial_database
    set_initial_port_number
    
    migrate
    sweep_cache
    save
    
    run_rails_tests
    
    start
  end
  
  # Sweep the cache
  def sweep_cache
    Dir.chdir(install_directory)
    message "Cleaning out #{@@app_name.capitalize}'s cache"
    status = system("rake -s sweep_cache > /dev/null 2> /dev/null")
  end
end