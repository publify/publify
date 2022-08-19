# frozen_string_literal: true

require "rails_helper"

describe Admin::UsersController, type: :controller do
  let!(:blog) { create :blog }
  let(:admin) { create(:user, :as_admin) }
  let(:publisher) { create(:user, :as_publisher) }
  let(:contributor) { create(:user, :as_contributor) }
  let(:strong_password) { "fhnehnhfiiuh" }

  render_views

  describe "#index" do
    let(:user) { admin }

    before do
      sign_in user
    end

    it "renders a list of users" do
      get :index
      assert_template "index"
      expect(assigns(:users)).not_to be_nil
    end

    describe "when you are not admin" do
      let(:user) { publisher }

      it "don't see the list of user" do
        get :index
        expect(response).to redirect_to(controller: "/admin/dashboard", action: "index")
      end
    end
  end

  describe "#new" do
    before do
      sign_in admin
    end

    it "renders the new template" do
      get :new
      assert_template "new"
    end
  end

  describe "#create" do
    before do
      sign_in admin
      post :create, params: { user: { login: "errand", email: "corey@test.com",
                                      password: strong_password,
                                      password_confirmation: strong_password,
                                      profile: User::CONTRIBUTOR,
                                      text_filter_name: "markdown",
                                      nickname: "fooo", firstname: "bar" } }
    end

    it "redirects to the index" do
      expect(response).to redirect_to(action: "index")
    end
  end

  describe "#update" do
    let(:user) { admin }

    before do
      sign_in user
    end

    it "redirects to index" do
      post :update, params: { id: contributor.id,
                              user: { login: "errand",
                                      email: "corey@test.com",
                                      password: strong_password,
                                      password_confirmation: strong_password } }
      expect(response).to redirect_to(action: "index")
    end

    it "skips blank passwords" do
      post :update, params: { id: contributor.id,
                              user: { login: "errand",
                                      password: "", password_confirmation: "" } }
      contributor.reload
      aggregate_failures do
        expect(response).to redirect_to(action: "index")
        expect(contributor).not_to be_valid_password("")
      end
    end

    describe "when you are not admin" do
      let(:user) { publisher }

      before do
        post :update, params: { id: contributor.id, user: { profile: User::PUBLISHER } }
      end

      it "redirects to login" do
        expect(response).to redirect_to(controller: "/admin/dashboard", action: "index")
      end

      it "does not change user profile" do
        u = contributor.reload
        expect(u.profile).to eq User::CONTRIBUTOR
      end
    end
  end
end
