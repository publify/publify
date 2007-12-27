desc "Force a sweeping run of typo's static page caches (all of them!)"
task :sweep_cache => :environment do
  PageCache.sweep_all
#  expire_meta_fragment(/.*/)
  puts "Cache swept."
end
