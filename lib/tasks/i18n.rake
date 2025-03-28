# frozen_string_literal: true

require "English"

namespace :i18n do
  desc "Check translation health"
  task :health do
    `bin/i18n-tasks health`
    abort("Translation problems found") unless $CHILD_STATUS.success?
  end
end

task lint: "i18n:health"
