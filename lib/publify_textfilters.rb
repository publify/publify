# frozen_string_literal: true

require "publify_plugins"
require "text_filter_plugin"

Rails.root.join("lib").glob("*_textfilter_*.rb").each do |file|
  require file.basename ".rb"
end
