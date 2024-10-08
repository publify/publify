# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!
require "factory_bot"
require "publify_core/testing_support/feed_assertions"

require "publify_core/testing_support/factories/articles"
require "publify_core/testing_support/factories/blogs"
require "publify_core/testing_support/factories/comments"
require "publify_core/testing_support/factories/contents"
require "publify_core/testing_support/factories/notes"
require "publify_core/testing_support/factories/pages"
require "publify_core/testing_support/factories/post_types"
require "publify_core/testing_support/factories/redirects"
require "publify_core/testing_support/factories/resources"
require "publify_core/testing_support/factories/sequences"
require "publify_core/testing_support/factories/sidebars"
require "publify_core/testing_support/factories/tags"
require "publify_core/testing_support/factories/trackbacks"
require "publify_core/testing_support/factories/users"

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

Rails.root.glob("spec/support/**/*.rb").each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

class ActionView::TestCase::TestController
  include Rails.application.routes.url_helpers
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join("spec/fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # shortcuts for factory_bot to use: create / build / build_stubbed
  config.include FactoryBot::Syntax::Methods

  # Test helpers needed for Devise
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature

  # Test helpers to check feed contents
  config.include PublifyCore::TestingSupport::FeedAssertions, type: :controller

  config.after :each, type: :controller do
    if response.media_type == "text/html" && response.body =~ /(&lt;[a-z]+)/
      raise "Double escaped HTML in text (#{Regexp.last_match(1)})"
    end
  end

  config.include FactoryBot::Syntax::Methods
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
