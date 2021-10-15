# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Themes", type: :request do
  before do
    create(:blog)
    henri = create(:user, :as_admin)
    sign_in henri
  end

  describe "GET /admin/themes/switchto" do
    it "is not available" do
      expect { get switchto_admin_themes_path(theme: "bootstrap-2") }.
        to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "POST /admin/themes/switchto" do
    it "redirects to the themes list" do
      post switchto_admin_themes_path(theme: "bootstrap-2")
      expect(response).to redirect_to admin_themes_path
    end
  end
end
