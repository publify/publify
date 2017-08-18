source 'https://rubygems.org'

if ENV['HEROKU']
  ruby '2.1.5'

  gem 'pg'
  gem 'rails_12factor'
  gem 'thin' # Change this to another web server if you want (ie. unicorn, passenger, puma...)
else

  require 'yaml'
  env = ENV['RAILS_ENV'] || 'development'
  dbfile = File.expand_path('../config/database.yml', __FILE__)

  unless File.exist?(dbfile)
    if ENV['DB']
      FileUtils.cp "config/database.yml.#{ENV['DB'] || 'postgres'}", 'config/database.yml'
    else
      raise 'You need to configure config/database.yml first'
    end
  end

  conf = YAML.load_file(dbfile)
  environment = conf[env]
  adapter = environment['adapter'] if environment
  raise 'You need define an adapter in your database.yml or set your RAILS_ENV variable' if adapter == '' || adapter.nil?
  case adapter
  when 'sqlite3'
    gem 'sqlite3'
  when 'postgresql'
    gem 'pg'
  when 'mysql2'
    gem 'mysql2', '~> 0.4.4'
  else
    raise "Don't know what gem to use for adapter #{adapter}"
  end
end

gem 'rails', '~> 5.0.4'

# Store sessions in the database
gem 'activerecord-session_store', '~> 1.1.0'

# Use Puma as the app server
gem 'puma', '~> 3.0'

gem 'publify_amazon_sidebar', path: 'publify_amazon_sidebar'
gem 'publify_core', path: 'publify_core'
gem 'publify_textfilter_code', path: 'publify_textfilter_code'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Needed for the lightbox and flickr text filters
gem 'flickraw', '~> 0.9.8', require: false

gem 'non-stupid-digest-assets', '~> 1.0'
gem 'rake', '~> 12.0'

# On Ruby 2.4.0, xmlrpc needs to be included as a gem
gem 'xmlrpc', '~> 0.3.0', platform: :mri_24

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0'

  gem 'capybara', '~> 2.7'
  gem 'factory_girl', '~> 4.5'
  gem 'i18n-tasks', '~> 0.9.1', require: false
  gem 'pry', '~> 0.10.3'
  gem 'pry-rails', '~> 0.3.4'
  gem 'rspec-rails', '~> 3.4'
  gem 'simplecov', '~> 0.14.0', require: false
end

group :development do
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'guard-rspec'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.0'
  gem 'spring-commands-cucumber', '~> 1.0'
  gem 'spring-commands-rspec', '~> 1.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
end

group :test do
  gem 'launchy', '~> 2.4'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'sqlite3'
  gem 'timecop', '~> 0.9.0'
  gem 'webmock', '~> 3.0.1'
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), 'themes', '**', 'Gemfile')) do |gemfile|
  eval(IO.read(gemfile), binding)
end
