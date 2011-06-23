desc "Force a sweeping run of typo's static page caches (all of them!)"
task :genethumb => :environment do
  require 'resource'
  r = Resource.find(:all)
  r.each do |res|
    puts res.filename
    res.create_thumbnail
  end
end
