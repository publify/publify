# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/test/fixtures'
  config.global_fixtures =
    %w{ blacklist_patterns blogs categories categorizations contents
        feedback notifications page_caches profiles redirects resources sidebars
        tags text_filters triggers users }

  config.before(:each) do
    CachedModel.cache_reset
    Localization.lang = :default
  end

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

def define_spec_public_cache_directory
  ActionController::Base.page_cache_directory = File.join(Rails.root, 'spec', 'public')
  unless File.exist? ActionController::Base.page_cache_directory
    FileUtils.mkdir_p ActionController::Base.page_cache_directory
  end
end

def create_file_in_spec_public_cache_directory(file)
  define_spec_public_cache_directory
  file_path = File.join(ActionController::Base.page_cache_directory, file)
  File.open(file_path, 'a').close
  file_path
end
