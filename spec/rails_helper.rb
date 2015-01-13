# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'rexml/document'
FactoryGirl.find_definitions

class EmailNotify
  class << self
    alias_method :real_send_user_create_notification, :send_user_create_notification
    def send_user_create_notification(_user); end
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

  # shortcuts for factory_girl to use: create / build / build_stubbed
  config.include FactoryGirl::Syntax::Methods
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
  expect(xml).not_to be_empty
  expect do
    assert REXML::Document.new(xml)
  end.not_to raise_error
end

def assert_atom10(feed, count)
  doc = Feedjira::Feed.parse(feed)
  expect(doc).to be_instance_of Feedjira::Parser::Atom
  expect(doc.title).not_to be_nil
  expect(doc.entries.count).to eq count
end

def assert_correct_atom_generator(feed)
  xml = Nokogiri::XML.parse(feed)
  generator = xml.css('generator').first
  expect(generator.content).to eq('Publify')
  expect(generator['version']).to eq(PUBLIFY_VERSION)
end

def assert_rss20(feed, count)
  doc = Feedjira::Feed.parse(feed)
  expect(doc).to be_instance_of Feedjira::Parser::RSS
  expect(doc.version).to eq '2.0'
  expect(doc.title).not_to be_nil
  expect(doc.entries.count).to eq count
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

# test standard view and all themes
def with_each_theme
  yield nil, ''
  Dir.new(File.join(::Rails.root.to_s, 'themes')).each do |theme|
    next if theme =~ /\.\.?/
    theme_dir = "#{::Rails.root}/themes/#{theme}"
    view_path = "#{theme_dir}/views"
    if File.exist?("#{theme_dir}/helpers/theme_helper.rb")
      require "#{theme_dir}/helpers/theme_helper.rb"
    end
    yield theme, view_path
  end
end
