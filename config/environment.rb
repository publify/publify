# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'

RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# need this early for plugins
require 'typo_deprecated'

class Rails::Configuration
  attr_accessor :action_web_service
end

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  config.frameworks -= [ :active_resource ]

  # Fix up action_web_service, see:
  # http://www.texperts.com/2007/12/21/using-action-web-service-with-rails-20/
  config.frameworks += [ :action_web_service ]

  config.action_web_service = Rails::OrderedOptions.new

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services )

  # I need the localization plugin to load first
  # Otherwise, I can't localize plugins <= localization
  # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
  config.plugins = [ 'localization', :all ]
  
  config.load_paths += %W(
    vendor/rubypants
    vendor/akismet
    vendor/redcloth/lib
    vendor/bluecloth/lib
    vendor/flickr
    vendor/gems/coderay
    vendor/sparklines/lib
    vendor/uuidtools/lib
    vendor/mocha/lib
    vendor/memcache-client/lib
    vendor/cached_model/lib
    vendor/rails/railties
    vendor/rails/railties/lib
    vendor/rails/actionpack/lib
    vendor/rails/activesupport/lib
    vendor/rails/activerecord/lib
    vendor/rails/actionmailer/lib
    vendor/actionwebservice/lib
    app/apis
  ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }

  # Declare the gems in vendor/gems, so that we can easily freeze and/or
  # install them.
  config.gem 'coderay'
  config.gem 'htmlentities'
  config.gem 'json'
  config.gem 'calendar_date_select'

  # Declare needed (github) gems
  # This is for legacy documentation, these gems are vendored for release.
  # config.gem 'datanoise-actionwebservice', :version => '2.2.2', :lib => 'actionwebservice', :source => 'http://gems.github.com'
  # config.gem 'mislav-will_paginate', :version => '2.3.7', :lib => 'will_paginate', :source => 'http://gems.github.com'
  # Rails 2.2.2 bug : decommenting this line forces the use of the test database regardless of the RAILS_ENV
  # config.gem 'rspec-rails', :lib => 'spec/rails', :version => '~> 1.1.11'

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  config.action_controller.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :email_notifier, :web_notifier

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

require 'migrator'
require 'rails_patch/active_record'
require 'login_system'
require 'typo_version'
$KCODE = 'u'
require 'jcode'
require 'xmlrpc_fix'
require 'transforms'
require 'builder'


#MemoryProfiler.start(:delay => 10, :string_debug => false)

unless Builder::XmlMarkup.methods.include? '_attr_value'
  # Builder 2.0 has many important fixes, but for now we will only backport
  # this one...
  class Builder::XmlMarkup
    # Insert the attributes (given in the hash).
    def _insert_attributes(attrs, order=[])
      return if attrs.nil?
      order.each do |k|
        v = attrs[k]
        @target << %{ #{k}="#{_attr_value(v)}"} if v # " WART
      end
      attrs.each do |k, v|
        @target << %{ #{k}="#{_attr_value(v)}"} unless order.member?(k) # " WART
      end
    end

   def _attr_value(value)
      case value
      when Symbol
        value.to_s
      else
        _escape(value.to_s).gsub(%r{"}, '&quot;')  # " WART
      end
    end
  end
end

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
)

ActionMailer::Base.default_charset = 'utf-8'

# I wanted to put this as a "setup" page, but it seems I can't catch the 
# exception fast enough and get a 500 error
if RAILS_ENV != 'test'
  begin
    ActiveRecord::Base.connection.select_all("select * from sessions")
  rescue
    begin
      ActiveRecord::Base.connection.current_database
      Migrator.migrate
    rescue
      # if there are no database, migrator doesn't no start
      # use case : rake db:create in rails tasks
    end
  end
end

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

#require 'memcache_util'
require 'cached_model'
CachedModel.use_local_cache = true
CachedModel.use_memcache = false
