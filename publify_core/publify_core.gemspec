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

  s.files = `git ls-files -z`.split("\x0").
    reject { |f| f.match(%r{^(bin|spec)/}) }

  s.required_ruby_version = '>= 2.2.0'

  s.add_dependency 'rails', '~> 5.0.0'
  s.add_dependency 'RedCloth', '~> 4.3.2'
  s.add_dependency 'aasm', '~> 4.12.0'
  s.add_dependency 'akismet', '~> 2.0'
  s.add_dependency 'bluecloth', '~> 2.1'
  s.add_dependency 'bootstrap-sass', '~> 3.3.6'
  s.add_dependency 'cancancan', '~> 2.0'
  s.add_dependency 'carrierwave', '~> 1.1.0'
  s.add_dependency 'devise', '~> 4.3.0'
  s.add_dependency 'devise-i18n', '~> 1.1.0'
  s.add_dependency 'dynamic_form', '~> 1.1.4'
  s.add_dependency 'feedjira', '~> 2.1.0'
  s.add_dependency 'fog-aws', '~> 1.3.0'
  s.add_dependency 'jquery-rails', '~> 4.3.1'
  s.add_dependency 'jquery-ui-rails', '~> 6.0.1'
  s.add_dependency 'kaminari', '~> 1.0.1'
  s.add_dependency 'mini_magick', '~> 4.2'
  s.add_dependency 'rails-timeago', '~> 2.0'
  s.add_dependency 'rails_autolink', '~> 1.1.0'
  s.add_dependency 'recaptcha', '~> 4.3.1'
  s.add_dependency 'rubypants', '~> 0.6.0'
  s.add_dependency 'mimemagic', '~> 0.3.2'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'twitter', '~> 6.1.0'
  s.add_dependency 'uuidtools', '~> 2.1.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'factory_girl_rails', '~> 4.8.0'
  s.add_development_dependency 'i18n-tasks', '~> 0.9.1'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.1'
  s.add_development_dependency 'timecop', '~> 0.8.1'
  s.add_development_dependency 'webmock', '~> 3.0.1'
  s.add_development_dependency 'simplecov', '~> 0.14.0'
end
