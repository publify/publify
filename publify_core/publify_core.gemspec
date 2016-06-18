$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "publify_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "publify_core"
  s.version     = PublifyCore::VERSION
  s.authors     = ["Matijs van Zuijlen", "Yannick François",
                   "Thomas Lecavellier", "Frédéric de Villamil"]
  s.email       = ["matijs@matijs.net"]
  s.homepage    = "https://publify.co"
  s.summary     = "Core engine for the Publify blogging system."
  s.description = "Core engine for the Publify blogging system, formerly known as Typo."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '~> 3.4.0'
  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'factory_girl_rails', '~> 4.6'
end
