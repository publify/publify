$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'publify_core/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'publify_core'
  s.version     = PublifyCore::VERSION
  s.authors     = ['Matijs van Zuijlen', 'Yannick François',
                   'Thomas Lecavellier', 'Frédéric de Villamil']
  s.email       = ['matijs@matijs.net']
  s.homepage    = 'https://publify.co'
  s.summary     = 'Core engine for the Publify blogging system.'
  s.description = 'Core engine for the Publify blogging system, formerly known as Typo.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'RedCloth', '~> 4.3.1'
  s.add_dependency 'activerecord-session_store', '~> 1.0.0'
  s.add_dependency 'akismet', '~> 2.0'
  s.add_dependency 'bluecloth', '~> 2.1'
  s.add_dependency 'bootstrap-sass', '~> 3.3.6'
  s.add_dependency 'cancancan', '~> 1.14'
  s.add_dependency 'carrierwave', '~> 0.11.2'
  s.add_dependency 'devise', '~> 4.2.0'
  s.add_dependency 'devise-i18n', '~> 1.1.0'
  s.add_dependency 'dynamic_form', '~> 1.1.4'
  s.add_dependency 'feedjira', '~> 2.0.0'
  s.add_dependency 'fog-aws', '~> 0.12.0'
  s.add_dependency 'jquery-rails', '~> 4.2.1'
  s.add_dependency 'jquery-ui-rails', '~> 5.0.2'
  s.add_dependency 'kaminari', '~> 0.17.0'
  s.add_dependency 'mini_magick', '~> 4.2'
  s.add_dependency 'rails-observers', '~> 0.1.2'
  s.add_dependency 'rails-timeago', '~> 2.0'
  s.add_dependency 'rails_autolink', '~> 1.1.0'
  s.add_dependency 'recaptcha', '~> 4.0.0'
  s.add_dependency 'rubypants', '~> 0.6.0'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'twitter', '~> 5.16.0'
  s.add_dependency 'uuidtools', '~> 2.1.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.5.2'
  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'factory_girl_rails', '~> 4.6'
  s.add_development_dependency 'rubocop', '~> 0.45.0'
  s.add_development_dependency 'i18n-tasks', '~> 0.9.1'
end
