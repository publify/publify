require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Publify
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #define default secret token to avoid information duplication
    $default_token = "08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a"

    # Setup the cache path
    config.action_controller.page_cache_directory = "#{::Rails.root.to_s}/public/cache/"
    config.cache_store=:file_store, "#{::Rails.root.to_s}/public/cache/"

    config.plugins = [ :all ]

    # Activate observers that should always be running
    config.active_record.observers = :email_notifier

    # Turn om timestamped migrations
    config.active_record.timestamped_migrations = true

    # To avoid exception when deploying on Heroku
    config.assets.initialize_on_precompile = false

    # Time to step into asset pipeline…
    config.assets.enabled = true

    # Mime type is fully determined by url
    config.action_dispatch.ignore_accept_header = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      DeviseController.layout 'accounts'
    end
  end

  # Load included libraries.
  require 'publify_sidebar'
  require 'publify_textfilters'
  require 'publify_avatar_gravatar'
  require 'publify_lang'
  ## Required by the plugins themselves.
  # require 'avatar_plugin'
  require 'email_notify'

  require 'format'
  require 'i18n_interpolation_deprecation'
  ## Required by the models themselves.
  # require 'spam_protection'
  require 'stateful'
  require 'transforms'
  require 'publify_time'
  require 'publify_guid'
  ## Required by the plugins themselves.
  # require 'publify_plugins'
  require 'publify_version'

  require 'theme'

  Theme.register_themes "#{Rails.root}/themes"

  Date::DATE_FORMATS.merge!(
    :long_weekday => '%a %B %e, %Y %H:%M'
  )

  # TimeZone
  if  File.file? "#{::Rails.root.to_s}/config/timezone.yml"
    Time.zone = YAML.load(File.read("#{::Rails.root.to_s}/config/timezone.yml"))
  end

  ActionMailer::Base.default :charset => 'utf-8'

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
end
