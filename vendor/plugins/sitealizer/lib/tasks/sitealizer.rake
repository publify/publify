namespace :sitealizer do
  desc "Removes the old 'sitemeter' and import the stored stats to Sitealizer"
  task :remove_sitemeter => :environment do
    ActiveRecord::Schema.drop_table('sitealizer') if SiteTracker.count == 0
    if ActiveRecord::Schema.tables.include?('sitemeter') && !ActiveRecord::Schema.tables.include?('sitealizer')
      ActiveRecord::Schema.rename_table('sitemeter','sitealizer')
      puts "Sitealizer => Completed renaming table from 'sitemeter' to 'sitealizer'" 
    end
    ['/public/images/sitemeter','/vendor/plugins/sitemeter'].each do |path|
      if File.exists?(RAILS_ROOT + path)
        FileUtils.rm_rf(RAILS_ROOT + path)
        puts "Sitealizer => Completed removing 'sitemeter' files from " + path 
      end
    end
  end
  
  desc "Updates Sitealizer to the latest version"
  task :update do
    $verbose = false
    `svn --version` rescue nil
    unless !$?.nil? && $?.success?
      $stderr.puts "ERROR: Must have subversion (svn) available in the PATH to update your Sitealizer plugin"
      exit 1
    end
    FileUtils.rm_rf(RAILS_ROOT+"vendor/plugins/sitealizer")
    system("svn export http://opensvn.csie.org/sitealizer vendor/plugins/sitealizer")
    system("ruby vendor/plugins/sitealizer/install.rb")
  end
  
  desc "Removes the Sitealizer plugin"
  task :uninstall => :environment do
    ActiveRecord::Schema.drop_table('sitealizer') if ActiveRecord::Schema.tables.include?('sitealizer')
    FileUtils.rm_rf(RAILS_ROOT+'/vendor/plugins/sitemeter') if File.exists?(RAILS_ROOT+'/vendor/plugins/sitemeter')
    puts "Sitealizer => plugin uninstalled\n\n"
  end
end