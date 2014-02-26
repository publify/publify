require 'yaml'
env = ENV["RAILS_ENV"] || 'development'
dbfile = File.expand_path("../config/database.yml", __FILE__)

unless File.exists?(dbfile)
  if ENV['DB']
    FileUtils.cp "config/database.yml.#{ENV['DB'] || 'postgres'}", 'config/database.yml'
  else
    raise "You need to configure config/database.yml first"
  end
end

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

source 'https://rubygems.org'

gem 'rails', '~> 3.2.16'
gem 'require_relative'
gem 'htmlentities'
gem 'bluecloth', '~> 2.1'
gem 'coderay', '~> 1.0.8'
gem 'kaminari'
gem 'RedCloth', '~> 4.2.8'
gem 'addressable', '~> 2.1', :require => 'addressable/uri'
gem 'mini_magick', '~> 3.6.0', :require => 'mini_magick'
gem 'uuidtools', '~> 2.1.1'
gem 'flickraw-cached'
gem 'rubypants', '~> 0.2.0'
gem 'rake', '~> 10.1.0'
#gem 'acts_as_list'
#gem 'acts_as_tree_rails3'
gem 'fog'
gem 'recaptcha', :require => 'recaptcha/rails', :branch => 'rails3'
gem 'carrierwave'
gem 'akismet', '~> 1.0'
gem 'twitter', '~> 5.2.0'

gem "jquery-rails", "~> 3.1.0"
gem "jquery-ui-rails", "~> 4.2.0"

gem 'rails_autolink', '~> 1.1.0'
gem 'dynamic_form', '~> 1.1.4'

gem 'iconv'

group :assets do
  gem 'sass-rails', " ~> 3.2.6"
  gem 'coffee-rails', " ~> 3.2.2"
  gem 'uglifier'
end

group :development, :test do
  gem 'thin'
  gem 'factory_girl', '~> 4.2.0'
  gem 'webrat'
  gem 'rspec-rails', '~> 2.14'
  gem 'simplecov', :require => false
  gem 'pry-rails'
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), 'themes', '**', "Gemfile")) do |gemfile|
  eval(IO.read(gemfile), binding)
end
