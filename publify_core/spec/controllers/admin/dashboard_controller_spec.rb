# frozen_string_literal: true

require "rails_helper"

describe Admin::DashboardController, type: :controller do
  render_views

  before do
    stub_request(:get, "http://www.google.com/search?output=rss&q=link:test.host&tbm=blg").
      to_return(status: 200, body: "", headers: {})
  end

  describe "test admin profile" do
    before do
      @blog ||= create(:blog)
      @henri = create(:user, :as_admin)
      sign_in @henri
      get :index
    end

    it "renders the index template" do
      expect(response.body).to render_template("index")
    end

    it "has a link to the theme" do
      expect(response.body).to have_selector("a[href='/admin/themes']", text: "change your blog presentation")
    end

    it "has a link to the sidebar" do
      expect(response.body).to have_selector("a[href='/admin/sidebar']", text: "enable plugins")
    end

    it "has a link to a new article" do
      expect(response.body).to have_selector("a[href='/admin/content/new']", text: "write a post")
    end

    it "has a link to a new page" do
      expect(response.body).to have_selector("a[href='/admin/pages/new']", text: "write a page")
    end

    it "has a link to article listing" do
      expect(response.body).to have_selector("a[href='/admin/content']", text: "no article")
    end

    it "has a link to user's article listing" do
      expect(response.body).to have_selector("a[href='/admin/content?search%5Buser_id%5D=#{@henri.id}']", text: "no article written by you")
    end

    it "has a link to drafts" do
      expect(response.body).to have_selector("a[href='/admin/content?search%5Bstate%5D=drafts']", text: "no draft")
    end

    it "has a link to pages" do
      expect(response.body).to have_selector("a[href='/admin/pages']", text: "no page")
    end

    it "has a link to total comments" do
      expect(response.body).to have_selector("a[href='/admin/feedback']", text: "no comment")
    end

    it "has a link to Spam" do
      expect(response.body).to have_selector("a[href='/admin/feedback?only=spam']", text: "no spam")
    end

    it "has a link to Spam queue" do
      expect(response.body).to have_selector("a[href='/admin/feedback?only=unapproved']", text: "no unconfirmed")
    end
  end

  describe "test publisher profile" do
    before do
      @blog ||= create(:blog)
      @rene = create(:user, :as_publisher)
      sign_in @rene
      get :index
    end

    it "renders the index template" do
      expect(response.body).to render_template("index")
    end

    it "does not have a link to the theme" do
      expect(response.body).not_to have_selector("a[href='/admin/themes']", text: "change your blog presentation")
    end

    it "does not have a link to the sidebar" do
      expect(response.body).not_to have_selector("a[href='/admin/sidebar']", text: "enable plugins")
    end

    it "has a link to a new article" do
      expect(response.body).to have_selector("a[href='/admin/content/new']", text: "write a post")
    end

    it "has a link to a new page" do
      expect(response.body).to have_selector("a[href='/admin/pages/new']", text: "write a page")
    end

    it "has a link to article listing" do
      expect(response.body).to have_selector("a[href='/admin/content']", text: "no article")
    end

    it "has a link to user's article listing" do
      expect(response.body).to have_selector("a[href='/admin/content?search%5Buser_id%5D=#{@rene.id}']", text: "no article written by you")
    end

    it "has a link to total comments" do
      expect(response.body).to have_selector("a[href='/admin/feedback']", text: "no comment")
    end

    it "has a link to Spam" do
      expect(response.body).to have_selector("a[href='/admin/feedback?only=spam']", text: "no spam")
    end

    it "has a link to Spam queue" do
      expect(response.body).to have_selector("a[href='/admin/feedback?only=unapproved']", text: "no unconfirmed")
    end
  end

  describe "test contributor profile" do
    before do
      @blog ||= create(:blog)
      @gerard = create(:user, :as_contributor)
      sign_in @gerard
      get :index
    end

    it "renders the index template" do
      expect(response.body).to render_template("index")
    end

    it "does not have a link to the theme" do
      expect(response.body).not_to have_selector("a[href='/admin/themes']", text: "change your blog presentation")
    end

    it "does not have a link to the sidebar" do
      expect(response.body).not_to have_selector("a[href='/admin/sidebar']", text: "enable plugins")
    end

    it "does not have a link to a new article" do
      expect(response.body).not_to have_selector("a[href='/admin/content/new']", text: "write a post")
    end

    it "does not have a link to a new article" do
      expect(response.body).not_to have_selector("a[href='/admin/pages/new']", text: "write a page")
    end

    it "does not have a link to article listing" do
      expect(response.body).not_to have_selector("a[href='/admin/content']", text: "Total posts:")
    end

    it "does not have a link to user's article listing" do
      expect(response.body).not_to have_selector("a[href='/admin/content?search%5Buser_id%5D=#{@gerard.id}']", text: "Your posts:")
    end

    it "does not have a link to categories" do
      expect(response.body).not_to have_selector("a[href='/admin/categories']", text: "Categories:")
    end

    it "does not have a link to total comments" do
      expect(response.body).not_to have_selector("a[href='/admin/feedback']", text: "Total comments:")
    end

    it "does not have a link to Spam" do
      expect(response.body).not_to have_selector("a[href='/admin/feedback?only=spam']", text: "no spam")
    end

    it "does not have a link to Spam queue" do
      expect(response.body).not_to have_selector("a[href='/admin/feedback?only=unapproved']", text: "no unconfirmed")
    end
  end
end
