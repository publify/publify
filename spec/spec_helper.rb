# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/test/fixtures/'
  config.global_fixtures =
    %w{ blacklist_patterns blogs categories categorizations contents
        feedback notifications page_caches profiles redirects resources sidebars
        tags text_filters triggers users }

  config.before(:each) do
    Localization.lang = :default
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

# TODO: Rewrite to be more RSpec-like instead of Test::Unit-like.
def assert_template_has(key=nil, message=nil)
  msg = build_message(message, "<?> is not a template object", key)
  assert_block(msg) { @response.has_template_object?(key) }
end

def assert_xml(xml)
  assert_nothing_raised do
    assert REXML::Document.new(xml)
  end
end

def this_blog
  Blog.default || Blog.create!
end

