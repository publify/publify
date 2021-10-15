# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  before do
    create(:blog)
    henri = create(:user, :as_admin)
    sign_in henri
  end

  describe "GET /admin" do
    it "tells the browser not to cache" do
      get admin_dashboard_path
      expect(response.headers["Cache-Control"]).
        to eq "private, no-cache, max-age=0, must-revalidate, no-store"
    end
  end
end
