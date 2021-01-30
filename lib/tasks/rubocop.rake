# frozen_string_literal: true

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new do |task|
    task.options << "--display-cop-names"
  end

  task lint: :rubocop

  desc "Regenerate RuboCop to-do files"
  task "rubocop:regenerate_todos" do
    sh "cd publify_core && rubocop --regenerate-todo"
    sh "cd publify_amazon_sidebar && rubocop --regenerate-todo"
    sh "cd publify_textfilter_code && rubocop --regenerate-todo"
    sh "rubocop --regenerate-todo"
  end
rescue LoadError
  # No rubocop available
  nil
end
