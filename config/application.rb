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

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end

  # Load included libraries.
  require "publify_sidebar"
  require "publify_textfilters"
  require "publify_plugins/gravatar"

  Theme.register_themes Rails.root.join("themes")
end
