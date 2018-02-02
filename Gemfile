source 'https://rubygems.org'

gem 'mysql2', '~> 0.4.4'
gem 'pg', '~> 0.21.0'
gem 'sqlite3'

gem 'rails', '~> 5.1.2'

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

group :development, :test do
  gem 'capybara', '~> 2.7'
  gem 'factory_girl', '~> 4.5'
  gem 'i18n-tasks', '~> 0.9.1', require: false
  gem 'rspec-rails', '~> 3.4'
  gem 'simplecov', '~> 0.15.1', require: false
end

group :development do
  gem 'better_errors', '~> 2.4.0'
  gem 'binding_of_caller', '~> 0.8.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.0'
  gem 'spring-commands-cucumber', '~> 1.0'
  gem 'spring-commands-rspec', '~> 1.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 10.0'
end

group :test do
  gem 'launchy', '~> 2.4'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'timecop', '~> 0.9.0'
  gem 'webmock', '~> 3.3.0'
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), 'themes', '**', 'Gemfile')) do |gemfile|
  eval(IO.read(gemfile), binding)
end
