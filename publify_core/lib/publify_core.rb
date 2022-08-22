# frozen_string_literal: true

require "devise"
require "devise-i18n"
require "devise_zxcvbn"

require "publify_core/version"
require "publify_core/engine"
require "publify_core/lang"

require "carrierwave"
require "dynamic_form"
require "jquery-rails"
require "jquery-ui-rails"
require "kaminari"
require "rails_autolink"
require "rails-timeago"
require "recaptcha/rails"
require "sassc-rails"

require "email_notify"
require "publify_guid"
require "publify_textfilter_none"
require "publify_textfilter_markdown"
require "publify_textfilter_smartypants"
require "publify_textfilter_textile"
require "publify_textfilter_twitterfilter"
require "publify_time"
require "sidebar_registry"
require "spam_protection"
require "text_filter_plugin"
require "theme"
require "transforms"

module PublifyCore
  Theme.register_themes File.join(Engine.root, "themes")

  SidebarRegistry.register_sidebar "ArchivesSidebar"
  SidebarRegistry.register_sidebar "MetaSidebar"
  SidebarRegistry.register_sidebar "PageSidebar"
  SidebarRegistry.register_sidebar "SearchSidebar"
  SidebarRegistry.register_sidebar "StaticSidebar"
  SidebarRegistry.register_sidebar "TagSidebar"

  # Mime type is fully determined by url
  Engine.config.action_dispatch.ignore_accept_header = true
end
