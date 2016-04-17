require 'English'

namespace :i18n do
  desc 'Check for missing translations'
  task :missing do
    puts `i18n-tasks missing`
    abort('Missing translations found') unless $CHILD_STATUS.success?
  end

  desc 'Check for unused translations'
  task :unused do
    puts `i18n-tasks unused`
    abort('Unused translations found') unless $CHILD_STATUS.success?
  end
end

task default: 'i18n:missing'
task default: 'i18n:unused'
