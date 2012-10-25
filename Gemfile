env = ENV["RAILS_ENV"] || 'development'
dbfile = File.expand_path("../config/database.yml", __FILE__)

unless File.exists?(dbfile)
  raise "You need to configure config/database.yml first"
else
  conf = YAML.load(File.read(dbfile))
  environment = conf[env]
  adapter = environment['adapter'] if environment
  raise "You need define an adapter in your database.yml or set your RAILS_ENV variable" if adapter == '' || adapter.nil?
  case adapter
  when 'sqlite3'
    gem 'sqlite3'
  when 'postgresql'
    gem 'pg'
  when 'mysql2'
    gem 'mysql2'
  else
    raise "Don't know what gem to use for adapter #{adapter}"
  end
end

source :rubygems

gem 'rails', '~> 3.2.6'
gem 'require_relative'
gem 'htmlentities'
gem 'json'
gem 'bluecloth', '~> 2.1'
gem 'coderay', '~> 0.9'
gem 'kaminari'
gem 'RedCloth', '~> 4.2.8'
gem 'addressable', '~> 2.1', :require => 'addressable/uri'
gem 'mini_magick', '~> 1.3.3', :require => 'mini_magick'
gem 'uuidtools', '~> 2.1.1'
gem 'flickraw-cached', :require => 'flickraw'
gem 'rubypants', '~> 0.2.0'
gem 'rake', '~> 0.9.2'
gem 'acts_as_list'
gem 'acts_as_tree_rails3'
gem 'fog'
gem 'recaptcha', :require => 'recaptcha/rails', :branch => 'rails3'

# TODO: Replace with jquery
gem 'prototype-rails', '~> 3.2.1'
gem 'prototype_legacy_helper', '0.0.0', :git => 'http://github.com/rails/prototype_legacy_helper.git'

gem 'rails_autolink', '~> 1.0.9'
gem 'dynamic_form', '~> 1.1.4'

group :development, :test do
  gem 'factory_girl', '~> 3.5'
  gem 'webrat'
  gem 'rspec-rails', '~> 2.11.0'
  gem 'simplecov', :require => false
end
