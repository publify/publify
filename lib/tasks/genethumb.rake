desc 'Force thumbnail creation for each resources'
task genethumb: :environment do
  require 'resource'
  r = Resource.find(:all)
  r.each do |res|
    puts res.filename
    res.create_thumbnail
  end
end
