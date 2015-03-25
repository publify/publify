source 'https://rubygems.org'
ruby '2.2.0'

gem 'dough-ruby', '~> 4.0', git: 'https://github.com/moneyadviceservice/dough.git', require: 'dough'
gem 'bowndler', git: 'https://github.com/moneyadviceservice/bowndler.git'

gem 'mysql2'
gem 'rails', '~> 4.2.1'
gem 'htmlentities'
gem 'bluecloth', '~> 2.1'
gem 'coderay', '~> 1.1.0'
gem 'kaminari'
gem 'RedCloth', '~> 4.2.8'
gem 'addressable', '~> 2.1', require: 'addressable/uri'
gem 'mini_magick', '~> 3.8.1', require: 'mini_magick'
gem 'uuidtools', '~> 2.1.1'
gem 'flickraw-cached'
gem 'rubypants', '~> 0.2.0'
gem 'rake', '~> 10.3.2'
gem 'fog'
gem 'recaptcha', require: 'recaptcha/rails', branch: 'rails3'
gem 'carrierwave', '~> 0.10.0'
gem 'akismet', '~> 1.0'
gem 'twitter', '~> 5.6.0'
gem 'jbuilder'
gem 'webpurify', require: 'web_purify'

gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 5.0.2'

gem 'rails-timeago', '~> 2.0'

gem 'rails_autolink', '~> 1.1.0'
gem 'dynamic_form', '~> 1.1.4'
gem 'sass-rails', ' ~> 4.0.3'
gem 'non-stupid-digest-assets'
gem 'mailjet'
gem 'unicorn'
gem 'responders', '~> 2.0'

# removed from Rails-core as Rails 4.0
gem 'actionpack-page_caching', '~> 1.0.2'
gem 'rails-observers', '~> 0.1.2'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'autoprefixer-rails'

gem 'oauth2', '1.0.0'
gem 'google-api-client', '0.7.1'
gem 'legato', '0.4.0'

group :assets do
  gem 'autoprefixer-rails'
  gem 'jshint_ruby'
  gem 'csslint_ruby'
  gem 'compass-rails'
  gem 'coffee-rails', ' ~> 4.0.1'
  gem 'uglifier'
end

group :development, :test do
  gem 'factory_girl', '~> 4.5.0'
  gem 'dotenv-rails'
  gem 'simplecov', require: false
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'guard-rails'
  gem 'guard-rspec', require: false
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-rubocop'
  gem 'spring-commands-rspec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'foreman'
  gem 'letter_opener'
  gem 'database_cleaner'
end

group :test do
  gem 'site_prism'
  gem 'capybara'
  gem 'rspec-rails', '~> 3.1.0'
end

group :staging, :production do
  gem 'pg'
  gem 'rails_12factor'
end
