# frozen_string_literal: true

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new do |task|
    task.options << "--display-cop-names"
  end

  task lint: :rubocop

  desc "Regenerate RuboCop to-do file"
  task "rubocop:regenerate_todos" do
    sh "rubocop --regenerate-todo"
  end
rescue LoadError
  # No rubocop available
  nil
end
