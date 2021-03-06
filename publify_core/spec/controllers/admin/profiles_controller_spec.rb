# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ProfilesController, type: :controller do
  render_views
  let!(:blog) { create(:blog) }
  let(:alice) { create(:user, :as_publisher, login: "alice") }

  before do
    sign_in alice
  end

  describe "#index" do
    it "renders index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#update" do
    it "redirects to profile page" do
      post :update, params: { id: alice.id, user: { email: "foo@bar.com" } }
      expect(response).to redirect_to("/admin/profiles")
    end

    it "does not allow updating your own profile" do
      post :update, params: { id: alice.id, user: { profile: User::ADMIN } }
      expect(alice.reload.profile).to eq User::PUBLISHER
    end

    it "skips blank passwords" do
      post :update,
           params: { id: alice.id, user: { login: "errand",
                                           password: "", password_confirmation: "" } }
      alice.reload
      aggregate_failures do
        expect(response).to redirect_to(action: "index")
        expect(alice).not_to be_valid_password("")
      end
    end
  end
end
