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
    %w{ blogs categories categorizations contents
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

# test standard view and all themes
def with_each_theme
  yield nil, ""
  Dir.new(File.join(RAILS_ROOT, "themes")).each do |theme|
    next if theme =~ /\.\.?/
    view_path = "#{RAILS_ROOT}/themes/#{theme}/views" 
    if File.exists?("#{RAILS_ROOT}/themes/#{theme}/helpers/theme_helper.rb")
      require "#{RAILS_ROOT}/themes/#{theme}/helpers/theme_helper.rb"
    end
    yield theme, view_path
  end
end

# This test now has optional support for validating the generated RSS feeds.
# Since Ruby doesn't have a RSS/Atom validator, I'm using the Python source
# for http://feedvalidator.org and calling it via 'system'.
#
# To install the validator, download the source from
# http://sourceforge.net/cvs/?group_id=99943
# Then copy src/feedvalidator and src/rdflib into a Python lib directory.
# Finally, copy src/demo.py into your path as 'feedvalidator', make it executable,
# and change the first line to something like '#!/usr/bin/python'.

if($validator_installed == nil)
  $validator_installed = false
  begin
    IO.popen("feedvalidator 2> /dev/null","r") do |pipe|
      if (pipe.read =~ %r{Validating http://www.intertwingly.net/blog/index.})
        puts "Using locally installed Python feed validator"
        $validator_installed = true
      end
    end
  rescue
    nil
  end
end

def assert_feedvalidator(rss, todo=nil)
  unless $validator_installed
    puts 'Not validating feed because no validator (feedvalidator in python) is installed'
    return
  end

  begin
    file = Tempfile.new('typo-feed-test')
    filename = file.path
    file.write(rss)
    file.close

    messages = ''

    IO.popen("feedvalidator file://#{filename}") do |pipe|
      messages = pipe.read
    end

    okay, messages = parse_validator_messages(messages)

    if todo && ! ENV['RUN_TODO_TESTS']
      assert !okay, messages + "\nTest unexpectedly passed!\nFeed text:\n"+rss
    else
      assert okay, messages + "\nFeed text:\n"+rss
    end
  end
end

def parse_validator_messages(message)
  messages=message.split(/\n/).reject do |m|
    m =~ /Feeds should not be served with the "text\/plain" media type/ ||
      m =~ /Self reference doesn't match document location/
  end

  if(messages.size > 1)
    [false, messages.join("\n")]
  else
    [true, ""]
  end
end

