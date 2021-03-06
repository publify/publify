# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PostTypesController, type: :controller do
  render_views

  before do
    create(:blog)
    user = create(:user, :as_admin)
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "create a new post_type" do
    it "creates a post and redirect to #index" do
      expect do
        post :create, params: { post_type: { name: "new post type" } }
        expect(response).to redirect_to(action: "index")
        expect(PostType.count).to eq(1)
        expect(PostType.first.name).to eq("new post type")
      end.to change(PostType, :count)
    end
  end

  describe "GET #edit" do
    before do
      get :edit, params: { id: create(:post_type).id }
    end

    it "renders the edit template with an HTTP 200 status code" do
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("edit")
    end
  end

  describe "#update an existing post_type" do
    it "updates a post_type and redirect to #index" do
      @test_id = create(:post_type).id
      post :update, params: { id: @test_id, post_type: { name: "another name" } }
      assert_response :redirect, action: "index"
      expect(PostType.count).to eq(1)
      expect(PostType.first.name).to eq("another name")
    end
  end

  describe "destroy a post_type" do
    it "destroys the post_type and redirect to #index" do
      @test_id = create(:post_type).id
      post :destroy, params: { id: @test_id }
      expect(response).to redirect_to(action: "index")
      expect(PostType.count).to eq(0)
    end
  end
end
