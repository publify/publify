require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Publify
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.plugins = [ :all ]

    # To avoid exception when deploying on Heroku
    config.assets.initialize_on_precompile = false
  end

  # Load included libraries.
  require 'publify_sidebar'
  require 'publify_textfilters'
  require 'publify_avatar_gravatar'
  ## Required by the plugins themselves.
  # require 'avatar_plugin'
  require 'email_notify'

  require 'format'
  ## Required by the models themselves.
  # require 'spam_protection'
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

      %w(delivery_method smtp_settings sendmail_settings file_settings).each do |key|
        ActionMailer::Base.send "#{key}=", mail_settings[key]
      end
    rescue
      # Fall back to using sendmail by default
      ActionMailer::Base.delivery_method = :sendmail
    end
  end
end
