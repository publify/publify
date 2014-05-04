source 'https://rubygems.org'

gem 'pg'
gem 'rails', '~> 3.2.16'
gem 'require_relative'
gem 'htmlentities'
gem 'bluecloth', '~> 2.1'
gem 'coderay', '~> 1.1.0'
gem 'kaminari'
gem 'RedCloth', '~> 4.2.8'
gem 'addressable', '~> 2.1', :require => 'addressable/uri'
gem 'mini_magick', '~> 3.7.0', :require => 'mini_magick'
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
gem 'twitter', '~> 5.6.0'

gem 'unicorn'

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
  gem 'capistrano', '~>2'
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
