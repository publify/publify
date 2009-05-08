begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

config = ActiveRecord::Base.configurations['wp25_test']
ActiveRecord::Base.configurations['wp25'] = config
ActiveRecord::Base.establish_connection config
file = "#{File.dirname(__FILE__)}/../db/wp25_schema.rb"
load(file)
ActiveRecord::Base.establish_connection

require 'factory_girl'
Dir[File.join(File.dirname(__FILE__), 'factories', '*.rb')].each {|f| require f}
