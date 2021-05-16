# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", ["~> 6.0.3", ">= 6.0.3.6"]

gem "mysql2"
gem "pg"
gem "sqlite3", "~> 1.4.0"

# Store sessions in the database
gem "activerecord-session_store", "~> 2.0.0"

# Use Puma as the app server
gem "puma", "~> 5.3.2"

gem "publify_amazon_sidebar", path: "publify_amazon_sidebar"
gem "publify_core", path: "publify_core"
gem "publify_textfilter_code", path: "publify_textfilter_code"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Needed for the lightbox and flickr text filters
gem "flickraw", "~> 0.9.8", require: false

gem "non-digest-assets", "~> 1.0"
gem "rake", "~> 13.0"
gem "reverse_markdown", "~> 2.0"

# Force older sprockets
gem "sprockets", "~> 3.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  gem "capybara", "~> 3.9"
  gem "factory_bot", "~> 6.1"
  gem "i18n-tasks", "~> 0.9.31", require: false
  gem "pry", "~> 0.14.0"
  gem "pry-rails", "~> 0.3.4"
  gem "rspec-rails", "~> 5.0"
  gem "rubocop", "~> 1.14.0", require: false
  gem "rubocop-performance", "~> 1.11.3", require: false
  gem "rubocop-rails", "~> 2.9.1", require: false
  gem "rubocop-rspec", "~> 2.2.0", require: false
  gem "simplecov", "~> 0.21.2", require: false
end

group :development do
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring", "~> 2.1.0"
  gem "spring-commands-cucumber", "~> 1.0"
  gem "spring-commands-rspec", "~> 1.0"

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 4.1"

  gem "rack-mini-profiler"

  gem "fast_stack"
  gem "flamegraph"
  gem "memory_profiler"
  gem "stackprof"
end

group :test do
  gem "feedjira", "~> 3.1"
  gem "launchy", "~> 2.4"
  gem "rails-controller-testing", "~> 1.0.1"
  gem "timecop", "~> 0.9.0"
  gem "webmock", "~> 3.3"
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), "themes", "**", "Gemfile")) do |gemfile|
  eval(IO.read(gemfile), binding)
end
