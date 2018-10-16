# frozen_string_literal: true

desc 'Run all specs in publify_core/spec directory'
task 'publify_core:spec' do
  sh 'cd publify_core && rake spec'
end

desc 'Run all specs in publify_amazon_sidebar/spec directory'
task 'publify_amazon_sidebar:spec' do
  sh 'cd publify_amazon_sidebar && rake spec'
end

desc 'Run all specs in publify_textfilter_code/spec directory'
task 'publify_textfilter_code:spec' do
  sh 'cd publify_textfilter_code && rake spec'
end

task default: 'publify_core:spec'
task default: 'publify_amazon_sidebar:spec'
task default: 'publify_textfilter_code:spec'
