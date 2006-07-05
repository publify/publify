require 'fileutils'
require 'readline'
require 'rubygems'
require 'yaml'
require 'digest/sha1'

class RailsInstaller
  include FileUtils
  attr_accessor :install_directory, :source_directory, :config
  attr_accessor :message_proc
  
  class InstallFailed < StandardError; end

  @@rails_version = nil
  
  def self.application_name(name)
    @@app_name = name
  end
  
  def self.support_location(location)
    @@support_location = location
  end
  
  def self.rails_version(svn_tag)
    @@rails_version = svn_tag
  end

  def initialize(install_directory)
    @install_directory = install_directory
    
    @config = read_yml(config_file) rescue nil
    @config ||= Hash.new
  end
  
  # Display a status message
  def message(string)
    if message_proc
      message_proc.call(string)
    else
      STDERR.puts string
    end
  end

  # Install Application
  def install(version=nil)
    @source_directory = find_source_directory(@@app_name,version)
    
    if config.size == 0
      @config = read_yml(backup_config_file)
    end
    
    install_sequence
    
    message ''
    message "#{@@app_name.capitalize} is now running on http://#{`hostname`.chomp}:#{config['port-number']}"
    message "Use '#{@@app_name} start #{install_directory}' to restart after boot."
    message "Look in installer/apache.conf.example to see how to integrate with Apache."
  end
  
  # The default install sequence.  Override this if you need to add extra
  # steps to the installer.
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
    save
    
    run_rails_tests
    
    start
  end
  
  
  # Start application in the background
  def start(foreground = false)
    return unless config['web-server'] == 'mongrel'
    
    args = {}
    args['-p'] = config['port-number']
    args['-a'] = config['bind-address']
    args['-e'] = config['rails-environment']
    args['-d'] = foreground
    args['-P'] = pid_file
    
    # Remove keys with nil values
    args.delete_if {|k,v| v==nil}
    
    args_array = args.to_a.flatten.map {|e| e.to_s}
    args_array = ['mongrel_rails', 'start', install_directory] + args_array
    message "Starting #{@@app_name.capitalize} on port #{config['port-number']}"
    system(args_array.join(' '))
  end
  
  # Stop application
  def stop
    return unless File.exists? pid_file
    return unless config['web-server'] == 'mongrel'
    
    args = {}
    args['-P'] = pid_file
    
    args_array = args.to_a.flatten.map {|e| e.to_s}
    args_array = ['mongrel_rails', 'stop', install_directory] + args_array
    message "Stopping #{@@app_name.capitalize}"
    system(args_array.join(' '))
  end
  
#  private

  # The name of the sqlite database file
  def db_file
    File.join(install_directory,'db','database.sqlite')
  end
    
  # Backup the database
  def backup_database
    return unless File.exists? db_file
    return unless config['database'] == 'sqlite'
    new_db_file = db_file+"-#{Time.now.strftime('%Y%m%d-%H%M')}.sql"
    
    message "Backing up existing SQLite database into #{new_db_file}"
    system("sqlite3 #{db_file} .dump > #{new_db_file}")
  end

  # Copy files from the source directory to the target directory.
  def copy_files
    message "Checking for existing #{@@app_name.capitalize} install in #{install_directory}"
    files_yml = File.join(install_directory,'installer','files.yml')
    old_files = read_yml(files_yml) rescue Hash.new
    
    message "Reading files from #{source_directory}"
    new_files = sha1_hash_directory_tree(source_directory)
    
    # Next, we compare the original install hash to the current hash.  For each
    # entry:
    #
    # - in new_file but not in old_files: copy
    # - in old files but not in new_files: delete
    # - in both, but hash different: copy
    # - in both, hash same: don't copy
    #
    # We really should add a third hash (existing_files) and compare against that
    # so we don't overwrite changed files.

    added, changed, deleted, same = hash_diff(old_files, new_files)
    
    if added.size > 0
      message "Copying #{added.size} new files into #{install_directory}"
      added.keys.sort.each do |file|
        message " copying #{file}"
        copy_one_file(file)
      end
    end
    
    if changed.size > 0
      message "Updating #{changed.size} files in #{install_directory}"
      changed.keys.sort.each do |file|
        message " updating #{file}"
        copy_one_file(file)
      end
    end
    
    if deleted.size > 0
      message "Deleting #{deleted.size} files from #{install_directory}"
      
      deleted.keys.sort.each do |file|
        message " deleting #{file}"
        rm(File.join(install_directory,file))
      end
    end
    
    write_yml(files_yml,new_files)
  end

  # Copy one file from source_directory to install_directory, creating directories as needed.
  def copy_one_file(filename)
    source_name = File.join(source_directory,filename)
    install_name = File.join(install_directory,filename)
    dir_name = File.dirname(install_name)
    
    mkdir_p(dir_name)
    cp(source_name,install_name,:preserve => true)
  end
  
  # Compute the different between two hashes.  Returns four hashes,
  # one contains the keys that are in 'b' but not in 'a' (added entries),
  # the next contains keys that are in 'a' and 'b', but have different values
  # (changed).  The third contains keys that are in 'b' but not 'a' (added).
  # The final hash contains items that are the same in each.
  def hash_diff(a, b)
    added = {}
    changed = {}
    deleted = {}
    same = {}
    
    seen = {}
    
    a.each_key do |k|
      seen[k] = true
      
      if b.has_key? k
        if b[k] == a[k]
          same[k] = true
        else
          changed[k] = true
        end
      else
        deleted[k] = true
      end
    end
    
    b.each_key do |k|
      unless seen[k]
        added[k] = true
      end
    end
    
    [added, changed, deleted, same]
  end
  
  # Freeze to a specific version of Rails
  def freeze_rails
    return unless @@rails_version
    version_file = File.join(install_directory,'vendor','rails-version')
    vendor_rails = File.join(install_directory,'vendor','rails')
    
    old_version = File.read(version_file).chomp rescue nil
    
    if @@rails_version == old_version
      return
    elsif old_version != nil
      rm_rf(vendor_rails)
      mkdir_p(vendor_rails)
    end
    
    package_map = {
      'rails' => File.join(vendor_rails,'railties'),
      'actionmailer' => File.join(vendor_rails,'actionmailer'),
      'actionpack' => File.join(vendor_rails,'actionpack'),
      'actionwebservice' => File.join(vendor_rails,'actionwebservice'),
      'activerecord' => File.join(vendor_rails,'activerecord'),
      'activesupport' => File.join(vendor_rails,'activesupport'),
    }
    
    specs = Gem.source_index.find_name('rails',["= #{@@rails_version}"])
    
    unless specs.to_a.size > 0
      raise InstallFailed, "Can't locate Rails #{@@rails_version}!"
    end
    
    copy_gem(specs.first, package_map[specs.first.name])
    
    specs.first.dependencies.each do |dep|
      next unless package_map[dep.name]
      
      dep_spec = Gem.source_index.find_name(dep.name,[dep.version_requirements.to_s])
      if dep_spec.size == 0
        raise InstallFailed, "Can't locate dependency #{dep.name} #{dep.version_requirements.to_s}"
      end
      
      copy_gem(dep_spec.first, package_map[dep.name])
    end
    
    File.open(version_file,'w') do |f|
      f.puts @@rails_version
    end
  end
  
  def copy_gem(spec, destination)
    message("copying #{spec.name} #{spec.version} to #{destination}")
    cp_r("#{spec.full_gem_path}/.",destination)
  end
  
  # Create all default config files
  def create_default_config_files
    create_default_database_yml
  end
  
  # Create the default database.yml
  def create_default_database_yml
    database_yml = File.join(install_directory,'config','database.yml')
    return if File.exist?(database_yml)
    return unless config['database'] == 'sqlite'
    
    message "Creating default database configuration file"
    cp("#{database_yml}.sqlite",database_yml)
  end
  
  # Create required directories, like tmp
  def create_directories
    mkdir_p(File.join(install_directory,'tmp','cache'))
    mkdir_p(File.join(install_directory,'tmp','session'))
    mkdir_p(File.join(install_directory,'tmp','sockets'))
    mkdir_p(File.join(install_directory,'log'))
    File.open(File.join(install_directory,'log','development.log'),'w')
    File.open(File.join(install_directory,'log','production.log'),'w')
    File.open(File.join(install_directory,'log','testing.log'),'w')
  end
  
  # Create the initial SQLite database
  def create_initial_database
    return if File.exists? db_file
    return unless config['database'] == 'sqlite'
    
    message "Creating initial #{@@app_name.capitalize} SQLite database"
    schema_file = File.join(install_directory,'db','schema.sqlite.sql')
    system("sqlite3 #{db_file} < #{schema_file}")
  end
  
  # Get the current schema version
  def get_schema_version
    File.read(File.join(install_directory,'db','schema_version')).to_i rescue 0
  end
  
  # The path to the installed config file
  def config_file
    File.join(install_directory,'installer','rails_installer.yml')
  end

  # The path to the config file that comes with the GEM
  def backup_config_file
    File.join(source_directory,'installer','rails_installer_defaults.yml')
  end
  
  # Pick a default port number
  def set_initial_port_number
    config['port-number'] ||= (rand(1000)+4000)
  end
  
  def pre_migrate_database
    old_schema_version = get_schema_version
    new_schema_version = File.read(File.join(source_directory,'db','schema_version')).to_i
    
    return unless old_schema_version > 0
    
    Dir.chdir(install_directory)
    
    # Are we downgrading?
    if old_schema_version > new_schema_version
      message "Downgrading schema from #{old_schema_version} to #{new_schema_version}"
      status = system("rake -s migrate VERSION=#{new_schema_version}")
      
      unless status
        raise InstallFailed, "Downgrade migrating from #{old_schema_version} to #{new_schema_version} failed."
      end
    end
  end
  
  # Migrate the database
  def migrate
    Dir.chdir(install_directory)
    message "Migrating #{@@app_name.capitalize}'s database to newest release"
    status = system("rake -s migrate")
    
    unless status
      raise InstallFailed, "Migration failed"
    end
  end

  # Sweep the cache
  def run_rails_tests
    Dir.chdir(install_directory)
    message "Running tests.  This may take a minute or two"
    status = system("rake -s test > /dev/null 2> /dev/null")
    
    if status
      message "All tests pass.  Congratulations."
    else
      message "***** Tests failed *****"
      message "** Please run 'rake test' by hand in your install directory."
      message "** Report problems to #{@@support_location}."
      message "***** Tests failed *****"
    end
  end

  def sha1_hash_directory_tree(directory, prefix='', hash={})
    Dir.entries(directory).each do |file|
      next if file =~ /^\./
      pathname = File.join(directory,file)
      if File.directory?(pathname)
        sha1_hash_directory_tree(pathname, File.join(prefix,file), hash)
      else
        hash[File.join(prefix,file)] = Digest::SHA1.hexdigest(File.read(pathname))
      end
    end
    
    hash
  end

  def save
    write_yml(config_file,@config)
  end
  
  def read_yml(filename)
    YAML.load(File.read(filename))
  end
  
  def write_yml(filename,object)
    File.open(filename,'w') do |f|
      f.write(YAML.dump(object))
    end
  end
  
  def pid_file
    File.join(install_directory,'tmp','pid.txt')
  end
  
  # Locate the source directory for a specific Version
  def find_source_directory(gem_name, version)
    if version == 'cwd'
      return Dir.pwd
    elsif version
      version_array = ["= #{version}"]
    else
      version_array = ["> 0.0.0"]
    end
    
    specs = Gem.source_index.find_name(gem_name,version_array)
    unless specs.to_a.size > 0
      raise InstallFailed, "Can't locate version #{version}!"
    end
    
    specs.last.full_gem_path
  end
  
  # Execute a command-line command
  def execute_command(*args)
    if args.size < 2
      display_help
      exit(1)
    end
    
    case args[0]
    when 'install'
      install(args[2])
    when 'upgrade'
      install(args[2])
    when 'start'
      start
    when 'stop'
      stop
    when 'run'
      start(true)
    when 'config'
      if args.size < 3
        config.keys.sort.each do |k|
          puts "#{k}=#{config[k]}"
        end
      else
        args[2..-1].each do |arg|
          if(arg=~/^([^=]+)=(.*)$/)
            config[$1.to_s]=$2.to_s
          else
            STDERR.puts "Unknown config command: #{arg}"
          end
        end
        save
      end
    else
      display_help('Unknown command')
    end
  end
  
  def display_help(error=nil)
    STDERR.puts error if error
    STDERR.puts "Commands:"
    STDERR.puts "  typo install DIRECTORY [VERSION]"
    STDERR.puts "     Installs Typo into DIRECTORY.  If there's an existing Typo install in"
    STDERR.puts "     DIRECTORY, then the installer will upgrade the installation instead."
    STDERR.puts "  typo start DIRECTORY"
    STDERR.puts "     Starts a Typo server in DIRECTORY."
    STDERR.puts "  typo stop DIRECTORY"
    STDERR.puts "     Shuts down a Typo server in DIRECTORY."
    STDERR.puts "  typo config DIRECTORY"
    STDERR.puts "     Shows configuration variables for Typo."
    STDERR.puts "  typo config DIRECTORY NAME=VALUE..."
    STDERR.puts "     Sets configuration variables for Typo."
  end
end
