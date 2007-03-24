require 'ftools'

dest_dir = File.dirname(__FILE__)+'/../../../public/images/sitealizer'
File.makedirs(dest_dir) unless File.exists?(dest_dir)

Dir[File.dirname(__FILE__)+'/lib/app/assets/images/*'].each do |src|
  File.copy(src, dest_dir+'/')
end

puts "
Sitealizer v.1.1 installed

Don't forget to add the following line to your config/routes.rb:
  map.connect '/sitealizer/:action', :controller => 'sitealizer'

== IMPORTANT ==
If you had previously installed 'sitemeter' you need to run the following if you want to import your stats:
  rake sitealizer:remove_sitemeter
  
Please visit http://sitealizer.rubyforge.org if you have any questions

"