begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new

  task default: :rubocop
rescue LoadError
end
