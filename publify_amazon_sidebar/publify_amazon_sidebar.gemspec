$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'publify_amazon_sidebar/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'publify_amazon_sidebar'
  s.version     = PublifyAmazonSidebar::VERSION
  s.authors     = ['Matijs van Zuijlen']
  s.email       = ['matijs@matijs.net']
  s.homepage    = 'https://publify.co'
  s.summary     = 'Amazon sidebar for the Publify blogging system.'
  s.description = 'Amazon sidebar for the Publify blogging system.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'publify_core', '~> 8.2.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.4.0'
end
