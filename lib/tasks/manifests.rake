# frozen_string_literal: true

desc 'Check manifest in publify_core/manifest:check directory'
task 'publify_core:manifest:check' do
  sh 'cd publify_core && rake manifest:check'
end

desc 'Check manifest in publify_amazon_sidebar/manifest:check directory'
task 'publify_amazon_sidebar:manifest:check' do
  sh 'cd publify_amazon_sidebar && rake manifest:check'
end

desc 'Check manifest in publify_textfilter_code/manifest:check directory'
task 'publify_textfilter_code:manifest:check' do
  sh 'cd publify_textfilter_code && rake manifest:check'
end

task default: 'publify_core:manifest:check'
task default: 'publify_amazon_sidebar:manifest:check'
task default: 'publify_textfilter_code:manifest:check'
