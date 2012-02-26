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
    config.action_controller.page_cache_directory = "#{::Rails.root.to_s}/public/cache/"
    config.cache_store=:file_store, "#{::Rails.root.to_s}/public/cache/"

    # I need the localization plugin to load first
    # Otherwise, I can't localize plugins <= localization
    # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
    config.plugins = [ :localization, :prototype_legacy_helper, :all ]

    config.autoload_paths += %W(
      app/apis
    ).map {|dir| "#{::Rails.root.to_s}/#{dir}"}.select { |dir| File.directory?(dir) }

    # Activate observers that should always be running
    config.active_record.observers = :email_notifier, :web_notifier

    # Filter sensitive parameters from the log file
    config.filter_parameters << :password
  end

  if RUBY_VERSION < "1.9"
    $KCODE = 'u'
    require 'jcode'
  end

  # Load included libraries.

  require 'action_web_service'
  ## Required by the plugins themselves.
  # require 'avatar_plugin'
  require 'email_notify'

  $FM_OVERWRITE = true
  require 'filemanager'

  require 'format'
  require 'i18n_interpolation_deprecation'
  require 'migrator'
  require 'route_cache'
  ## Required by the models themselves.
  # require 'spam_protection'
  require 'stateful'
  require 'transforms'
  require 'typo_guid'
  ## Required by the plugins themselves.
  # require 'typo_plugins'
  require 'bare_migration'
  require 'typo_version'
  require 'rails_patch/active_support'

  require "#{Rails.root.to_s}/vendor/plugins/typo_login_system/lib/login_system"
  require "#{Rails.root.to_s}/vendor/akismet/akismet"

  Date::DATE_FORMATS.merge!(
    :long_weekday => '%a %B %e, %Y %H:%M'
  )

  ActionMailer::Base.default :charset => 'utf-8'

  # Work around interpolation deprecation problem: %d is replaced by
  # {{count}}, even when we don't want them to.
  # FIXME: We should probably fully convert to standard Rails I18n.
  class I18n::Backend::Simple
    def interpolate(locale, string, values = {})
      interpolate_without_deprecated_syntax(locale, string, values)
    end
  end

  if ::Rails.env != 'test'
    begin
      mail_settings = YAML.load(File.read("#{::Rails.root.to_s}/config/mail.yml"))

      ActionMailer::Base.delivery_method = mail_settings['method']
      ActionMailer::Base.server_settings = mail_settings['settings']
    rescue
      # Fall back to using sendmail by default
      ActionMailer::Base.delivery_method = :sendmail
    end
  end

  if ::Rails.env.production?
    # http://markcatley.tumblr.com/post/393941962/deploying-typo-to-heroku
    require 'fileutils'

    file_utils_no_write = ::FileUtils::NoWrite
    Object.send :remove_const, :FileUtils
    ::FileUtils = file_utils_no_write
  end
end
