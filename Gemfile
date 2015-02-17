source 'https://rubygems.org'

if ENV['HEROKU']
  ruby '2.1.5'

  gem 'pg'
  gem 'thin' # Change this to another web server if you want (ie. unicorn, passenger, puma...)
  gem 'rails_12factor'
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

  conf = YAML.load(File.read(dbfile))
  environment = conf[env]
  adapter = environment['adapter'] if environment
  raise 'You need define an adapter in your database.yml or set your RAILS_ENV variable' if adapter == '' || adapter.nil?
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

gem 'rails', '~> 4.2.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.3'

gem 'jquery-ui-rails', '~> 5.0.2'
gem 'RedCloth', '~> 4.2.8'
gem 'actionpack-page_caching', '~> 1.0.2' # removed from Rails-core as Rails 4.0
gem 'addressable', '~> 2.1', require: 'addressable/uri'
gem 'akismet', '~> 1.0'
gem 'bluecloth', '~> 2.1'
gem 'carrierwave', '~> 0.10.0'
gem 'coderay', '~> 1.1.0'
gem 'dynamic_form', '~> 1.1.4'
gem 'flickraw-cached'
gem 'fog'
gem 'htmlentities'
gem 'kaminari'
gem 'mini_magick', '~> 4.0.2', require: 'mini_magick'
gem 'non-stupid-digest-assets'
gem 'rails-observers', '~> 0.1.2'
gem 'rails-timeago', '~> 2.0'
gem 'rails_autolink', '~> 1.1.0'
gem 'rake', '~> 10.4.2'
gem 'recaptcha', require: 'recaptcha/rails', branch: 'rails3'
gem 'rubypants', '~> 0.2.0'
gem 'twitter', '~> 5.13.0'
gem 'uuidtools', '~> 2.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'thin'
  gem 'factory_girl', '~> 4.5.0'
  gem 'capybara'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'simplecov', require: false
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller'
  gem 'guard-rspec'
  gem 'quiet_assets'
end

group :test do
  gem 'feedjira'
  gem 'codeclimate-test-reporter', require: nil
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), 'themes', '**', 'Gemfile')) do |gemfile|
  eval(IO.read(gemfile), binding)
end
