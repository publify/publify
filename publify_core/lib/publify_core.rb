require 'devise'
require 'devise-i18n'

require 'publify_core/engine'
require 'publify_core/lang'

require 'actionpack/page_caching'
require 'activerecord/session_store'
require 'bootstrap-sass'
require 'carrierwave'
require 'dynamic_form'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'kaminari'
# Ensure Rails Observers defines ActiveRecord::Observer before loading
# sweeping.rb. Otherwise, Sweeper won't be defined.
# TODO: Replace or update rails-observers
require 'rails/observers/activerecord/active_record'
require 'rails-observers'
require 'rails_autolink'
require 'rails-timeago'
require 'recaptcha/rails'
require 'sass-rails'

require 'email_notify'
require 'publify_guid'
require 'publify_textfilter_none'
require 'publify_textfilter_markdown'
require 'publify_textfilter_smartypants'
require 'publify_textfilter_textile'
require 'publify_textfilter_twitterfilter'
require 'publify_time'
require 'sidebar_registry'
require 'spam_protection'
require 'stateful'
require 'text_filter_plugin'
require 'theme'
require 'transforms'

# TODO: Handle this differently than with a global variable
# define default secret token to avoid information duplication
$default_token = '08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a'

module PublifyCore
  Theme.register_themes File.join(Engine.root, 'themes')

  SidebarRegistry.register_sidebar 'ArchivesSidebar'
  SidebarRegistry.register_sidebar 'MetaSidebar'
  SidebarRegistry.register_sidebar 'PageSidebar'
  SidebarRegistry.register_sidebar 'SearchSidebar'
  SidebarRegistry.register_sidebar 'StaticSidebar'
  SidebarRegistry.register_sidebar 'TagSidebar'

  # Mime type is fully determined by url
  Engine.config.action_dispatch.ignore_accept_header = true
end
