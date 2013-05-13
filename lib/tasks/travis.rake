desc "copies the Travis config file at the good place"
task :travis => :environment do
  FileUtils.cp "config/database.yml.#{ENV['DB'] || 'postgres'}", 'config/database.yml'
end
