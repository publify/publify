# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(spec: 'app:db:test:prepare')

task default: :spec

namespace :manifest do
  def gemmable_files
    `git ls-files -z`.split("\x0").reject do |file|
      file.match(%r{^(bin|spec)/}) ||
        file.match(%r{/\.keep$}) ||
        %w(.gitignore .rspec Manifest.txt Rakefile publify_textfilter_code.gemspec).include?(file)
    end
  end

  def manifest_files
    File.open('Manifest.txt').readlines.map(&:chomp)
  end

  desc 'Create manifest'
  task :create do
    File.open('Manifest.txt', 'w') do |manifest|
      gemmable_files.each { |file| manifest.puts file }
    end
  end

  desc 'Check manifest'
  task :check do
    abort 'Manifest check failed' unless gemmable_files == manifest_files
  end
end
task default: 'manifest:check'
