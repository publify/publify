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
  when 'mysql'
    gem 'sam-mysql-ruby'
  else
    raise "Don't know what gem to use for adapter #{adapter}"
  end
end

source :rubygems

gem 'rails', '~> 3.0.10'
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
gem 'flickraw-cached'
gem 'rubypants', '~> 0.2.0'
gem 'rake', '~> 0.9.2'
gem 'acts_as_list'
gem 'acts_as_tree_rails3'
gem 'recaptcha', :require => 'recaptcha/rails', :branch => 'rails3'

group :development, :test do
  gem 'factory_girl', '~> 3.5'
  gem 'webrat'
  gem 'rspec-rails', '~> 2.0'
  gem 'simplecov', :require => false
end
