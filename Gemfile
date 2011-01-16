env = ENV["RAILS_ENV"] || 'development'
dbfile = File.join("config", "database.yml")

unless File.exists?(dbfile)
  puts "You need to configure config/database.yml first"
  puts "Exiting"
  exit
else
  conf = YAML.load(File.read(dbfile))
  adapter = conf[env]['adapter']
  raise "You need define an adapter in your database.yml" if adapter == '' || adapter.nil?
  case adapter
  when 'sqlite3'
    gem 'sqlite3-ruby'
  when 'postgresql'
    gem 'pg'
  when 'mysql'
    gem 'mysql'
  else
    raise "Don't know what gem to use for adapter #{adapter}"
  end
end

require 'fileutils'
require 'yaml'

source :gemcutter
gem 'rails', '3.0.0'
gem 'htmlentities'
gem 'json'
gem 'bluecloth', '~> 2.0.5'
gem 'coderay', '~> 0.9'
gem 'will_paginate', '~> 3.0.pre2'
gem 'RedCloth', '~> 4.2.2'
gem 'addressable', '~> 2.1.0', :require => 'addressable/uri'
gem 'mini_magick', '~> 1.3', :require => 'mini_magick'
gem 'uuidtools', '~>2.1.1'
gem 'flickr', '~> 1.0.2'
gem 'rubypants', '~> 0.2.0'
gem 'acts_as_list'
gem 'acts_as_tree_rails3'

group :development, :test do
  gem 'ruby-debug'
  gem 'factory_girl'
  gem 'webrat'
  gem 'rspec-rails', '>= 2.0.0.beta.20'
  gem 'rcov'
end
