begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:test_files] = 'spec/**/*_spec.rb'
  end
rescue LoadError
end
