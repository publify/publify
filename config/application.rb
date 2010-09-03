require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module TypoBlog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  
    # Setup the cache path
    config.action_controller.page_cache_directory = "#{RAILS_ROOT}/public/cache/"
    config.cache_store=:file_store, "#{RAILS_ROOT}/public/cache/"
  
    # I need the localization plugin to load first
    # Otherwise, I can't localize plugins <= localization
    # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
    config.plugins = [ :localization, :all ]
  
    config.autoload_paths += %W(
      vendor/akismet
      app/apis
    ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }
  
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
  require 'vendor/plugins/typo_login_system/lib/login_system'
  require 'typo_version'
  $KCODE = 'u'
  require 'jcode'
  require 'transforms'
  
  $FM_OVERWRITE = true
  require 'filemanager'
  
  Date::DATE_FORMATS.merge!(
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
end
