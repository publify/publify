env = ENV["RAILS_ENV"] || 'development'
dbfile = File.expand_path("../config/database.yml", __FILE__)

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
    if RUBY_VERSION.include?('1.9')
      gem 'sam-mysql-ruby'
    else
      gem 'mysql'
    end
  else
    raise "Don't know what gem to use for adapter #{adapter}"
  end
end

require 'fileutils'
require 'yaml'

source :gemcutter
gem 'rails', '3.0.8'
gem 'require_relative'
gem 'htmlentities'
gem 'json'
gem 'bluecloth', '>= 2.0.5'
gem 'coderay', '~> 0.9'
gem 'will_paginate', '~> 3.0.pre2'
gem 'RedCloth', '~> 4.2.2'
gem 'addressable', '~> 2.1.0', :require => 'addressable/uri'
gem 'mini_magick', '>= 1.3', :require => 'mini_magick'
gem 'uuidtools', '~>2.1.1'
gem 'flickraw', '~> 0.8.3'
gem 'rubypants', '~> 0.2.0'
gem 'rake', '>= 0.9.2' 
gem 'acts_as_list'
gem 'acts_as_tree_rails3'

group :development, :test do
  if RUBY_VERSION.include?('1.9')
    gem 'ruby-debug19'
  else
    gem 'ruby-debug'
  end
  gem 'factory_girl'
  gem 'webrat'
  gem 'rspec-rails', '>= 2.0.0.beta.20'
  gem 'rcov'
end
