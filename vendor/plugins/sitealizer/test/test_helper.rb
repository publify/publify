require File.dirname(__FILE__) + '/../../../../config/environment'
require 'rubygems'
require 'test/unit'
require 'active_record/fixtures'
require 'action_controller/test_process'

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"