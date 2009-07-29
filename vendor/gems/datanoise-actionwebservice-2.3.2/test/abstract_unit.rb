$: << "#{File.dirname(__FILE__)}/../lib"
ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'test/unit'
require 'action_web_service'
require 'action_controller'
require 'action_controller/test_case'
require 'action_view'
require 'action_view/test_case'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true


ActiveRecord::Base.logger = ActionController::Base.logger = Logger.new("debug.log")

begin
  require 'activerecord'
  require "active_record/test_case"
  require "active_record/fixtures" unless Object.const_defined?(:Fixtures)
rescue LoadError => e
  fail "\nFailed to load activerecord: #{e}"
end

ActiveRecord::Base.configurations = {
  'mysql' => {
    :adapter  => "mysql",
    :username => "root",
    :encoding => "utf8",
    :database => "actionwebservice_unittest"
  }
}

ActiveRecord::Base.establish_connection 'mysql'

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = "#{File.dirname(__FILE__)}/fixtures/"
end
