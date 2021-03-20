# frozen_string_literal: true

require "bundler/gem_helper"

# Tasks related to installation as a gem
namespace :publify_core do
  task :build => "manifest:check"
  Bundler::GemHelper.install_tasks dir: "publify_core"
end

namespace :publify_amazon_sidebar do
  task :build => "manifest:check"
  Bundler::GemHelper.install_tasks dir: "publify_amazon_sidebar"
end

namespace :publify_textfilter_code do
  task :build => "manifest:check"
  Bundler::GemHelper.install_tasks dir: "publify_textfilter_code"
end

task release: "publify_core:release"
task release: "publify_amazon_sidebar:release"
task release: "publify_textfilter_code:release"
