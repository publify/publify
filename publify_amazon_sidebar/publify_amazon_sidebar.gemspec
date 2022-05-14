# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "publify_amazon_sidebar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "publify_amazon_sidebar"
  s.version     = PublifyAmazonSidebar::VERSION
  s.authors     = ["Matijs van Zuijlen"]
  s.email       = ["matijs@matijs.net"]
  s.homepage    = "https://publify.github.io/"
  s.summary     = "Amazon sidebar for the Publify blogging system."
  s.description = "Amazon sidebar for the Publify blogging system."
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.5.0"

  s.files = File.open("Manifest.txt").readlines.map(&:chomp)

  s.add_dependency "publify_core", "~> 9.2.8"

  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "simplecov", "~> 0.18.5"
  s.add_development_dependency "sqlite3"
end
