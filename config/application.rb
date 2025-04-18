# frozen_string_literal: true

require_relative "boot"

# FIXME: remove when upgrading to Rails 7.1
require "logger"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Publify
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end

  # Load included libraries.
  require "publify_sidebar"
  require "publify_textfilters"
  require "publify_plugins/gravatar"

  Theme.register_themes Rails.root.join("themes")
end
