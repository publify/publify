require 'database_cleaner'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'rexml/document'
require 'site_prism'
FactoryGirl.find_definitions

class EmailNotify
  class << self
    alias real_send_user_create_notification send_user_create_notification
    def send_user_create_notification _user; end
  end
end

class ActionView::TestCase::TestController
  include Rails.application.routes.url_helpers
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

module RSpec
  module Core
    module Hooks
      class HookCollection
        def find_hooks_for(group)
          self.class.new(select { |hook| hook.options_apply?(group) })
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.order = :random

  Kernel.srand config.seed

  config.include SessionHelpers, type: :feature

  # shortcuts for factory_girl to use: create / build / build_stubbed
  config.include FactoryGirl::Syntax::Methods

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    # TODO: Disable :should syntax
    mocks.syntax = [:expect, :should]
    # TODO: Enable this and fix the resulting problems
    # mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:transaction)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def define_spec_public_cache_directory
  ActionController::Base.page_cache_directory = File.join(Rails.root, 'spec', 'public')
  unless File.exist? ActionController::Base.page_cache_directory
    FileUtils.mkdir_p ActionController::Base.page_cache_directory
  end
end

def path_for_file_in_spec_public_cache_directory(file)
  define_spec_public_cache_directory
  File.join(ActionController::Base.page_cache_directory, file)
end

def create_file_in_spec_public_cache_directory(file)
  file_path = path_for_file_in_spec_public_cache_directory(file)
  File.open(file_path, 'a').close
  file_path
end

# TODO: Clean up use of these Test::Unit style expectations
def assert_xml(xml)
  expect do
    assert REXML::Document.new(xml)
  end.not_to raise_error
end

def assert_atom10 feed, count
  doc = Nokogiri::XML.parse(feed)
  root = doc.css(':root').first
  expect(root.name).to eq('feed')
  expect(root.namespace.href).to eq('http://www.w3.org/2005/Atom')
  expect(root.css('entry').count).to eq(count)
end

def assert_rss20 feed, count
  doc = Nokogiri::XML.parse(feed)
  root = doc.css(':root').first
  expect(root.name).to eq('rss')
  expect(root['version']).to eq('2.0')
  expect(root.css('channel item').count).to eq(count)
end

def assert_json feed, count
  expect(JSON.parse(feed).count).to eq(count)
end

def stub_full_article(time = Time.now)
  author = FactoryGirl.build_stubbed(User, name: 'User Name')
  text_filter = FactoryGirl.build(:textile)

  a = FactoryGirl.build_stubbed(Article, published_at: time, user: author,
                 created_at: time, updated_at: time,
                 title: 'Foo Bar', permalink: 'foo-bar',
                 guid: time.hash)
  allow(a).to receive(:published_comments) { [] }
  allow(a).to receive(:resources) { [FactoryGirl.build(:resource)] }
  allow(a).to receive(:tags) { [FactoryGirl.build(:tag)] }
  allow(a).to receive(:text_filter) { text_filter }
  a
end
