require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/profiles_controller'

# Re-raise errors caught by the controller.
class Admin::ProfilesController; def rescue_action(e) raise e end; end

describe Admin::ProfilesController do
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
