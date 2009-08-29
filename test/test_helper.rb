ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  self.use_instantiated_fixtures  = false

  fixtures :all

  # Add more helper methods to be used by all tests here...
end
