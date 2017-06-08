# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rails-controller-testing'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_girl'
require 'rexml/document'
require 'feedjira'
require 'webmock/rspec'

FactoryGirl.find_definitions

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = File.join(PublifyCore::Engine.root, 'spec', 'fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # shortcuts for factory_girl to use: create / build / build_stubbed
  config.include FactoryGirl::Syntax::Methods

  # Test helpers needed for Devise
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
end

def file_upload(file = 'testfile.txt', mime_type = 'text/plain')
  Rack::Test::UploadedFile.new(File.join(ActionDispatch::IntegrationTest.fixture_path, file),
                               mime_type)
end

def engine_root
  PublifyCore::Engine.instance.root
end

# test standard view and all themes
def with_each_theme
  yield nil, ''
  Theme.find_all.each do |theme|
    theme_dir = theme.path
    view_path = "#{theme_dir}/views"
    if File.exist?("#{theme_dir}/helpers/theme_helper.rb")
      require "#{theme_dir}/helpers/theme_helper.rb"
    end
    yield theme.name, view_path
  end
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
  expect(generator['version']).to eq(PublifyCore::VERSION)
end

def assert_rss20(feed, count)
  doc = Feedjira::Feed.parse(feed)
  expect(doc).to be_instance_of Feedjira::Parser::RSS
  expect(doc.version).to eq '2.0'
  expect(doc.title).not_to be_nil
  expect(doc.entries.count).to eq count
end

def stub_full_article(time = Time.now, blog: Blog.first)
  author = FactoryGirl.build_stubbed(:user, name: 'User Name')
  text_filter = FactoryGirl.build(:textile)

  a = FactoryGirl.build_stubbed(:article,
                                published_at: time, user: author,
                                created_at: time, updated_at: time,
                                title: 'Foo Bar', permalink: 'foo-bar',
                                blog: blog,
                                guid: time.hash)
  allow(a).to receive(:published_comments) { [] }
  allow(a).to receive(:resources) { [FactoryGirl.build(:resource)] }
  allow(a).to receive(:tags) { [FactoryGirl.build(:tag)] }
  allow(a).to receive(:text_filter) { text_filter }
  a
end
