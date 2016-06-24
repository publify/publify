require "publify_core/engine"

require 'actionpack/page_caching'
require 'carrierwave'
require 'devise'
require 'kaminari'
require 'rails_autolink'

require 'publify_guid'
require 'publify_textfilter_none'
require 'publify_textfilter_textile'
require 'publify_textfilter_twitterfilter'
require 'publify_time'
require 'spam_protection'
require 'stateful'
require 'text_filter_plugin'
require 'theme'
require 'transforms'

module PublifyCore
  Theme.register_themes File.join(Engine.instance.root, 'themes')
end
