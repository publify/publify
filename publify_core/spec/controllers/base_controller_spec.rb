# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseController, type: :controller do
  describe "#set_paths" do
    it "adds the theme's path to the view path" do
      theme = Theme.find "plain"
      create :blog, theme: "plain"
      controller.send :set_paths
      paths = controller.view_paths.map(&:to_path)
      expect(paths).to include "#{theme.path}/views"
    end
  end
end
