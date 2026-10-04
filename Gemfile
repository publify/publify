# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 4.0.7"

gem "rails", "~> 7.2.4"

gem "pg"
gem "rails_12factor"

# Store sessions in the database
gem "activerecord-session_store", "~> 2.3.0"

# Use Puma as the app server
gem "puma", "~> 8.0"

gem "publify_amazon_sidebar", "~> 11.0.0"
gem "publify_core", "~> 11.0.0"
gem "publify_textfilter_code", "~> 11.0.0"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Needed for the lightbox and flickr text filters
gem "flickraw", "~> 0.9.8", require: false

gem "non-digest-assets", "~> 2.0"
gem "rake", "~> 13.0"
gem "reverse_markdown", "~> 3.0"

# Force newer sprockets
gem "sprockets", "~> 4.0"

# Allow throttling requests
gem "rack-attack", "~> 6.5"

gem "net-smtp", "~> 0.5.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :windows]

  gem "capybara", "~> 3.9"
  gem "factory_bot", "~> 6.2"
  gem "i18n-tasks", "~> 1.1.0", require: false
  gem "rspec-rails", "~> 8.0"
  gem "rubocop", "~> 1.91", require: false
  gem "rubocop-capybara", "~> 3.0", require: false
  gem "rubocop-factory_bot", "~> 2.28", require: false
  gem "rubocop-performance", "~> 1.27", require: false
  gem "rubocop-rails", "~> 2.37", require: false
  gem "rubocop-rspec", "~> 3.10", require: false
  gem "rubocop-rspec_rails", "~> 2.32", require: false
  gem "simplecov", "~> 1.2", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem "web-console", "~> 4.1"

  gem "listen", "~> 3.3"
  # Display performance information such as SQL time and flame graphs for each
  # request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 5.0"
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring", "~> 4.7.0"
  gem "spring-commands-rspec", "~> 1.0"

  gem "fast_stack"
  gem "flamegraph"
  gem "memory_profiler"
  gem "stackprof"
end

group :test do
  # TODO: Remove when upgrading rails and/or rspec-rails
  gem "drb", "~> 2.2.3"
  gem "mutex_m", "~> 0.3.0"

  gem "feedjira", "~> 4.0"
  gem "launchy", "~> 3.0"
  gem "rails-controller-testing", "~> 1.0.1"
  gem "shoulda-matchers", "~> 7.0"
  gem "timecop", "~> 0.9.1"
  gem "webmock", "~> 3.3"
end

# Install gems from each theme
Dir.glob(File.join(File.dirname(__FILE__), "themes", "**", "Gemfile")) do |gemfile|
  eval(File.read(gemfile), binding)
end

gem "dockerfile-rails", ">= 1.5", group: :development
gem "selma", "0.5.2"
