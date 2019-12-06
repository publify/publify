# frozen_string_literal: true

source "https://rubygems.org"

# Dependencies are specified in publify_amazon_sidebar.gemspec.
gemspec

if File.exist? File.join("..", "publify_core")
  gem "publify_core", path: "../publify_core"
else
  gem "publify_core", git: "https://github.com/publify/publify_core.git"
end
