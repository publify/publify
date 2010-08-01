# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Setup the cache path
  config.action_controller.page_cache_directory = "#{RAILS_ROOT}/public/cache/"
  config.cache_store=:file_store, "#{RAILS_ROOT}/public/cache/"

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'htmlentities'
  config.gem 'json'
  config.gem 'calendar_date_select'
  config.gem 'bluecloth', :version => '~> 2.0.5'
  config.gem 'coderay', :version => '~> 0.8'
  config.gem 'will_paginate', :version => '~> 2.3.11'
  config.gem 'RedCloth', :version => '~> 4.2.2'
  config.gem 'fdv-actionwebservice', :version => '2.3.8', :lib => 'actionwebservice'
  config.gem 'addressable', :version => '~> 2.1.0', :lib => 'addressable/uri'
  config.gem 'mini_magick', :version => '~> 1.3', :lib => 'mini_magick'
  config.gem 'uuidtools', :version => '~>2.1.1'
  config.gem 'flickr', :version => '~> 1.0.2'
  config.gem 'rubypants', :version => '~> 0.2.0'

  # I need the localization plugin to load first
  # Otherwise, I can't localize plugins <= localization
  # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
  config.plugins = [ :localization, :all ]

  config.load_paths += %W(
    vendor/akismet
    app/apis
  ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_resource ]

  # Disable use of the Accept header, since it causes bad results with our
  # static caching (e.g., caching an atom feed as index.html).
  config.action_controller.use_accept_header = false

  # Activate observers that should always be running
  config.active_record.observers = :email_notifier, :web_notifier
end

# Load included libraries.
#require 'uuidtools'

require 'migrator'
require 'rails_patch/active_record'
require 'rails_patch/active_support'
require 'login_system'
require 'typo_version'
$KCODE = 'u'
require 'jcode'
require 'transforms'

$FM_OVERWRITE = true
require 'filemanager'

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
)

ActionMailer::Base.default_charset = 'utf-8'

# Work around interpolation deprecation problem: %d is replaced by
# {{count}}, even when we don't want them to.
# FIXME: We should probably fully convert to standard Rails I18n.
require 'i18n_interpolation_deprecation'
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
