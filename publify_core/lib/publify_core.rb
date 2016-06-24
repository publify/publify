require "publify_core/engine"
require 'publify_core/lang'


require 'actionpack/page_caching'
require 'carrierwave'
require 'devise'
require 'dynamic_form'
require 'kaminari'
require 'rails-observers'
require 'rails_autolink'

require 'email_notify'
require 'publify_guid'
require 'publify_textfilter_none'
require 'publify_textfilter_markdown'
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
#define default secret token to avoid information duplication
$default_token = "08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a"

module PublifyCore
  Theme.register_themes File.join(Engine.root, 'themes')
  SidebarRegistry.register_sidebar_directory(File.join(Engine.root, 'lib'),
                                             Engine.config.eager_load_paths)

  # Mime type is fully determined by url
  Engine.config.action_dispatch.ignore_accept_header = true
end
