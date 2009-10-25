require File.dirname(__FILE__) + "/../spec_helper"

describe Sidebar do
  it "test_available_sidebars" do
    assert Sidebar.available_sidebars.size >= 6
  end
end
