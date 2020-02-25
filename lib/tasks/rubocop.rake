# frozen_string_literal: true

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new do |task|
    task.options << "--display-cop-names"
  end

  task lint: :rubocop
rescue LoadError
  # No rubocop available
  nil
end
