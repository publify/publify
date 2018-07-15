# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'factory_bot'
require 'rexml/document'
FactoryBot.find_definitions

class ActionView::TestCase::TestController
  include Rails.application.routes.url_helpers
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.infer_spec_type_from_file_location!

  # shortcuts for factory_bot to use: create / build / build_stubbed
  config.include FactoryBot::Syntax::Methods

  # Test helpers needed for Devise
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.after :each, type: :controller do
    raise "Double escaped HTML in text (#{Regexp.last_match(1)})" if response.body =~ /(&lt;[a-z]+)/
  end
end

# Test installed themes
def with_each_theme
  Theme.find_all.each do |theme|
    theme_dir = theme.path
    view_path = "#{theme_dir}/views"
    helper_file = "#{theme_dir}/helpers/theme_helper.rb"
    require helper_file if File.exist?(helper_file)
    yield theme.name, view_path
  end
end
