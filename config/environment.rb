# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'

RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  config.frameworks -= [ :active_resource ]

  # Setup the cache path
  config.action_controller.page_cache_directory = "#{RAILS_ROOT}/public/cache/"
  config.cache_store=:file_store, "#{RAILS_ROOT}/public/cache/"


  # I need the localization plugin to load first
  # Otherwise, I can't localize plugins <= localization
  # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
  config.plugins = [ :localization, :all ]
  
  config.load_paths += %W(
    vendor/rubypants
    vendor/akismet
    vendor/flickr
    vendor/uuidtools/lib
    vendor/rails/railties
    vendor/rails/railties/lib
    vendor/rails/actionpack/lib
    vendor/rails/activesupport/lib
    vendor/rails/activerecord/lib
    vendor/rails/actionmailer/lib
    app/apis
  ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }

  # Declare the gems in vendor/gems, so that we can easily freeze and/or
  # install them.
  config.gem 'htmlentities'
  config.gem 'json'
  config.gem 'calendar_date_select'
  config.gem 'bluecloth', :version => '~> 2.0.5'
  config.gem 'coderay', :version => '~> 0.8'
  config.gem 'will_paginate', :version => '~> 2.3.11'
  config.gem 'RedCloth', :version => '~> 4.2.2'
  config.gem 'panztel-actionwebservice', :version => '2.3.5', :lib => 'actionwebservice'
  config.gem 'addressable', :version => '~> 2.1.0', :lib => 'addressable/uri'
  config.gem 'mini_magick', :version => '~> 1.2.5', :lib => 'mini_magick'
  
  # Use the filesystem for sessions instead of the database
  config.action_controller.session = { :key => "_typo_session", :secret => "8d7879bd56b9470b659cdcae88792622" }
  
  # Disable use of the Accept header, since it causes bad results with our
  # static caching (e.g., caching an atom feed as index.html).
  config.action_controller.use_accept_header = false

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :email_notifier, :web_notifier
end

# Load included libraries.
require 'rubypants'
require 'uuidtools'

require 'migrator'
require 'rails_patch/active_record'
require 'login_system'
require 'typo_version'
$KCODE = 'u'
require 'jcode'
require 'transforms'

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
)

ActionMailer::Base.default_charset = 'utf-8'

# Work around interpolation deprecation problem: %d is replaced by
# {{count}}, even when we don't want them to.
# FIXME: We should probably fully convert to standard Rails I18n.
class I18n::Backend::Simple
  def interpolate(locale, string, values = {})
    interpolate_without_deprecated_syntax(locale, string, values)
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
