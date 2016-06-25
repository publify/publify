# frozen_string_literal: true

require "rails_helper"

describe SidebarConfiguration, type: :model do
  describe "::setting" do
    let(:dummy_sidebar) do
      Class.new(SidebarConfiguration) do
        setting :foo, "default-foo"
      end
    end

    it "creates a reader method with default value on instances" do
      dummy = dummy_sidebar.new
      expect(dummy.foo).to eq "default-foo"
    end

    it "provides the default value to instances created earlier" do
      dummy = dummy_sidebar.new

      dummy_sidebar.instance_eval do
        setting :bar, "default-bar"
      end

      expect(dummy.config).not_to have_key("bar")
      expect(dummy.bar).to eq "default-bar"
    end
  end
end
