require 'English'

namespace :i18n do
  task :missing do
    puts `i18n-tasks missing`
    abort('Missing translations found') unless $CHILD_STATUS.success?
  end

  task :unused do
    puts `i18n-tasks unused`
    abort('Unused translations found') unless $CHILD_STATUS.success?
  end
end

task default: 'i18n:missing'
task default: 'i18n:unused'
