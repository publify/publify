# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PagesController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, :as_admin) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "without params" do
      before { get :index }

      it { expect(response).to be_successful }
      it { expect(response).to render_template("index") }
      it { expect(assigns(:pages)).not_to be_nil }
    end

    context "with page 1" do
      before { get :index, params: { page: 1 } }

      it { expect(response).to be_successful }
      it { expect(response).to render_template("index") }
      it { expect(assigns(:pages)).not_to be_nil }
    end
  end

  describe "GET #new" do
    context "should get a new form" do
      before { get :new }

      it { expect(response).to be_successful }
      it { expect(response).to render_template("new") }
      it { expect(assigns(:page)).not_to be_nil }
      it { expect(assigns(:page).user).to eq(user) }
      it { expect(assigns(:page).text_filter.name).to eq("markdown smartypants") }
      it { expect(assigns(:page)).to be_published }
    end
  end

  describe "POST #create" do
    context "should create a new page" do
      def base_page(options = {})
        { title: "posted via tests!",
          body: "A good body",
          state: "published",
          name: "posted-via-tests" }.merge(options)
      end

      context "simple" do
        before do
          post :create, params: {
            page: {
              name: "new_page", title: "New Page Title", body: "Emphasis _mine_,
              arguments *strong*"
            },
          }
        end

        it { expect(Page.first.name).to eq("new_page") }
        it { expect(response).to redirect_to(action: :index) }
      end

      it "creates a published page with a redirect" do
        post :create, params: { "page" => base_page }
        expect(assigns(:page).redirect).not_to be_nil
      end

      it "creates an unpublished page without a redirect" do
        post :create, params: { "page" => base_page(state: :unpublished) }
        expect(assigns(:page).redirect).to be_nil
      end

      it "creates a page published in the future without a redirect" do
        # TODO: published_at parameter is currently ignored
        skip
        post :create, params: { "page" => base_page(published_at: 1.hour.from_now.to_s) }
        expect(assigns(:page).redirect).to be_nil
      end
    end
  end

  describe "#edit" do
    let!(:page) { create(:page) }

    context "should get the edit page" do
      before { get :edit, params: { id: page.id } }

      it { expect(response).to be_successful }
      it { expect(response).to render_template("edit") }
      it { expect(assigns(:page)).to eq(page) }
    end
  end

  describe "#update" do
    let!(:page) { create(:page) }

    context "should update a post" do
      before do
        post :update,
             params: { id: page.id,
                       page: { name: "markdown-page",
                               title: "Markdown Page",
                               body: "Adding a [link](https://publify.github.io/) here" } }
      end

      it { expect(response).to redirect_to(action: :index) }
    end
  end

  describe "destroy" do
    let!(:page) { create(:page) }

    before { post :destroy, params: { id: page.id } }

    it { expect(response).to redirect_to(action: :index) }
    it { expect(Page.count).to eq(0) }
  end
end
