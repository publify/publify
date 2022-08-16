# frozen_string_literal: true

# Maintain your gem's version:
require_relative "lib/publify_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "publify_core"
  s.version     = PublifyCore::VERSION
  s.authors     = ["Matijs van Zuijlen", "Yannick François",
                   "Thomas Lecavellier", "Frédéric de Villamil"]
  s.email       = ["matijs@matijs.net"]
  s.homepage    = "https://publify.github.io/"
  s.summary     = "Core engine for the Publify blogging system."
  s.description = "Core engine for the Publify blogging system, formerly known as Typo."
  s.license     = "MIT"

  s.files       = File.open("Manifest.txt").readlines.map(&:chomp)

  s.required_ruby_version = ">= 2.5.0"

  s.add_dependency "aasm", "~> 5.0"
  s.add_dependency "akismet", "~> 3.0"
  s.add_dependency "cancancan", "~> 3.0"
  s.add_dependency "carrierwave", "~> 2.2.1"
  s.add_dependency "commonmarker", "~> 0.23.2"
  s.add_dependency "devise", "~> 4.8.0"
  s.add_dependency "devise-i18n", "~> 1.2"
  s.add_dependency "fog-aws", "~> 3.2"
  s.add_dependency "fog-core", "~> 2.2"
  s.add_dependency "html-pipeline", "~> 2.14"
  s.add_dependency "html-pipeline-hashtag", "~> 0.1.2"
  s.add_dependency "jquery-rails", "~> 4.5.0"
  s.add_dependency "jquery-ui-rails", "~> 6.0.1"
  s.add_dependency "kaminari", ["~> 1.2", ">= 1.2.1"]
  s.add_dependency "marcel", "~> 1.0.0"
  s.add_dependency "mini_magick", ["~> 4.9", ">= 4.9.4"]
  # Force minimum nokogiri version to avoid security issues
  s.add_dependency "nokogiri", ">= 1.12.5"
  s.add_dependency "psych", "~> 4.0"
  s.add_dependency "rack", ">= 2.2.3"
  s.add_dependency "rails", "~> 6.1.4"
  s.add_dependency "rails_autolink", "~> 1.1.0"
  s.add_dependency "rails-i18n", "~> 6.0.0"
  s.add_dependency "rails-timeago", "~> 2.0"
  s.add_dependency "recaptcha", ["~> 5.0"]
  s.add_dependency "rubypants", "~> 0.7.0"
  s.add_dependency "sassc-rails", "~> 2.0"
  s.add_dependency "twitter", "~> 7.0.0"
  s.add_dependency "uuidtools", "~> 2.2.0"

  s.add_development_dependency "capybara", "~> 3.0"
  s.add_development_dependency "factory_bot", "~> 6.2"
  s.add_development_dependency "feedjira", "~> 3.2"
  s.add_development_dependency "i18n-tasks", "~> 0.9.1"
  s.add_development_dependency "pry"
  s.add_development_dependency "rails-controller-testing", "~> 1.0.1"
  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "shoulda-matchers", "~> 4.5"
  s.add_development_dependency "simplecov", "~> 0.21.2"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "timecop", "~> 0.9.1"
  s.add_development_dependency "webmock", "~> 3.3"
  s.metadata["rubygems_mfa_required"] = "true"
end
