source 'https://rubygems.org'

if ENV['HEROKU']
  ruby '2.1.5'

  gem 'pg'
  gem 'rails_12factor'
  gem 'thin' # Change this to another web server if you want (ie. unicorn, passenger, puma...)
else
  gem 'sqlite3'
  gem 'pg'
  gem 'mysql2', '~> 0.4.4'
end

gem 'rails', '~> 5.1.2'

# Store sessions in the database
gem 'activerecord-session_store', '~> 1.1.0'

# Use Puma as the app server
gem 'puma', '~> 3.0'

gem 'publify_amazon_sidebar', path: 'publify_amazon_sidebar'
gem 'publify_core', path: 'publify_core'
gem 'publify_textfilter_code', path: 'publify_textfilter_code'

gem 'tzinfo-data'

gem 'execjs'
gem 'therubyracer', :platforms => :ruby

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Needed for the lightbox and flickr text filters
gem 'flickraw', '~> 0.9.8', require: false

gem 'non-stupid-digest-assets', '~> 1.0'
gem 'rake', '~> 12.0'

# On Ruby 2.4.0, xmlrpc needs to be included as a gem
gem 'xmlrpc', '~> 0.3.0', platform: :mri_24

group :development, :test do
  gem 'capybara', '~> 2.7'
  gem 'factory_girl', '~> 4.5'
  gem 'i18n-tasks', '~> 0.9.1', require: false
  gem 'rspec-rails', '~> 3.4'
  gem 'simplecov', '~> 0.15.1', require: false
end

group :development do
  gem 'better_errors', '~> 2.3.0'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'guard-rspec'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.0'
  gem 'spring-commands-cucumber', '~> 1.0'
  gem 'spring-commands-rspec', '~> 1.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0'

  # Get a nice featureful IRB console.
  # Add "require 'irbtools'" to your .irbrc to activate this
  gem 'irbtools', '~> 2.0', platform: :mri_24, require: false
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
