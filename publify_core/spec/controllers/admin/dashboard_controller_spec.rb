# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DashboardController, type: :controller do
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
      expect(response.body).to have_link("change your blog presentation",
                                         href: "/admin/themes")
    end

    it "has a link to the sidebar" do
      expect(response.body).to have_link("enable plugins", href: "/admin/sidebar")
    end

    it "has a link to a new article" do
      expect(response.body).to have_link("write a post", href: "/admin/articles/new")
    end

    it "has a link to a new page" do
      expect(response.body).to have_link("write a page", href: "/admin/pages/new")
    end

    it "has a link to article listing" do
      expect(response.body).to have_link("no article", href: "/admin/articles")
    end

    it "has a link to user's article listing" do
      expect(response.body).
        to have_link("no article written by you",
                     href: "/admin/articles?search%5Buser_id%5D=#{@henri.id}")
    end

    it "has a link to drafts" do
      expect(response.body).
        to have_link("no draft",
                     href: "/admin/articles?search%5Bstate%5D=drafts")
    end

    it "has a link to pages" do
      expect(response.body).to have_link("no page",
                                         href: "/admin/pages")
    end

    it "has a link to total comments" do
      expect(response.body).to have_link("no comment",
                                         href: "/admin/feedback")
    end

    it "has a link to Spam" do
      expect(response.body).to have_link("no spam",
                                         href: "/admin/feedback?only=spam")
    end

    it "has a link to Spam queue" do
      expect(response.body).to have_link("no unconfirmed",
                                         href: "/admin/feedback?only=unapproved")
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
      expect(response.body).not_to have_link("change your blog presentation",
                                             href: "/admin/themes")
    end

    it "does not have a link to the sidebar" do
      expect(response.body).not_to have_link("enable plugins",
                                             href: "/admin/sidebar")
    end

    it "has a link to a new article" do
      expect(response.body).to have_link("write a post",
                                         href: "/admin/articles/new")
    end

    it "has a link to a new page" do
      expect(response.body).to have_link("write a page",
                                         href: "/admin/pages/new")
    end

    it "has a link to article listing" do
      expect(response.body).to have_link("no article",
                                         href: "/admin/articles")
    end

    it "has a link to user's article listing" do
      expect(response.body).
        to have_link("no article written by you",
                     href: "/admin/articles?search%5Buser_id%5D=#{@rene.id}")
    end

    it "has a link to total comments" do
      expect(response.body).to have_link("no comment",
                                         href: "/admin/feedback")
    end

    it "has a link to Spam" do
      expect(response.body).to have_link("no spam",
                                         href: "/admin/feedback?only=spam")
    end

    it "has a link to Spam queue" do
      expect(response.body).to have_link("no unconfirmed",
                                         href: "/admin/feedback?only=unapproved")
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
      expect(response.body).not_to have_link("change your blog presentation",
                                             href: "/admin/themes")
    end

    it "does not have a link to the sidebar" do
      expect(response.body).not_to have_link("enable plugins",
                                             href: "/admin/sidebar")
    end

    it "does not have a link to a new article" do
      expect(response.body).not_to have_link("write a post",
                                             href: "/admin/articles/new")
    end

    it "does not have a link to a new article" do
      expect(response.body).not_to have_link("write a page",
                                             href: "/admin/pages/new")
    end

    it "does not have a link to article listing" do
      expect(response.body).not_to have_link("Total posts:",
                                             href: "/admin/articles")
    end

    it "does not have a link to user's article listing" do
      expect(response.body).
        not_to have_link("Your posts:",
                         href: "/admin/articles?search%5Buser_id%5D=#{@gerard.id}")
    end

    it "does not have a link to categories" do
      expect(response.body).not_to have_link("Categories:",
                                             href: "/admin/categories")
    end

    it "does not have a link to total comments" do
      expect(response.body).not_to have_link("Total comments:",
                                             href: "/admin/feedback")
    end

    it "does not have a link to Spam" do
      expect(response.body).not_to have_link("no spam",
                                             href: "/admin/feedback?only=spam")
    end

    it "does not have a link to Spam queue" do
      expect(response.body).
        not_to have_link("no unconfirmed",
                         href: "/admin/feedback?only=unapproved")
    end
  end
end
