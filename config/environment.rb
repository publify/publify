# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services )
  config.load_paths += %W(
    vendor/rubypants
    vendor/redcloth/lib
    vendor/bluecloth/lib
    vendor/flickr
    vendor/syntax/lib
    vendor/sparklines/lib
    vendor/uuidtools/lib
    vendor/jabber4r/lib
    vendor/rails/railties
    vendor/rails/railties/lib
    vendor/rails/actionpack/lib
    vendor/rails/activesupport/lib
    vendor/rails/activerecord/lib
    vendor/rails/actionmailer/lib
    vendor/rails/actionwebservice/lib
  ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  # config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below

# Load included libraries.
require 'redcloth'
require 'bluecloth'
require 'rubypants'
require 'flickr'
require 'uuidtools'

require_dependency 'migrator'
require_dependency 'rails_patch/components'
require_dependency 'rails_patch/active_record'
require_dependency 'theme'
require_dependency 'login_system'
require_dependency 'typo_version'
require_dependency 'jabber'
require_dependency 'email'
require_dependency 'metafragment'
require_dependency 'actionparamcache'
$KCODE = 'u'
require_dependency 'jcode'
require_dependency 'aggregations/audioscrobbler'
require_dependency 'aggregations/delicious'
require_dependency 'aggregations/tada'
require_dependency 'aggregations/flickr'
require_dependency 'aggregations/fortythree'
require_dependency 'aggregations/magnolia'
require_dependency 'aggregations/upcoming'
require_dependency 'config_manager'
require_dependency 'blog'
require_dependency 'spam_protection'
require_dependency 'xmlrpc_fix'
require_dependency 'guid'
require_dependency 'transforms'

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
)

ActionController::Base.enable_upload_progress

ActionMailer::Base.default_charset = 'utf-8'

if RAILS_ENV != 'test'
  begin
    mail_settings = YAML.load(File.read("#{RAILS_ROOT}/config/mail.yml"))

    ActionMailer::Base.delivery_method = mail_settings['method']
    ActionMailer::Base.server_settings = mail_settings['settings']
  rescue
    # Fall back to using sendmail by default
    ActionMailer::Base.delivery_method = :sendmail
  end
end

FLICKR_KEY='84f652422f05b96b29b9a960e0081c50'
DEFAULT_BLOG_ID=1
