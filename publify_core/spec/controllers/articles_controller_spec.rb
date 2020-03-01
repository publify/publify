# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  describe "#tag" do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    it "redirects to TagsContoller#index" do
      get :tag

      expect(response).to redirect_to(tags_path)
    end
  end

  describe "#index" do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    context "without any parameters" do
      let!(:article) { create(:article) }
      let!(:note) { create(:note) }

      before do
        get :index
      end

      it { expect(response).to render_template(:index) }
      it { expect(assigns[:articles]).not_to be_empty }

      it "has no meta keywords for a blog without keywords" do
        expect(assigns(:keywords)).to eq("")
      end
    end

    context "for a month" do
      before do
        create(:article, published_at: Time.utc(2004, 4, 23))
        get "index", params: { year: 2004, month: 4 }
      end

      it "renders template index" do
        expect(response).to render_template(:index)
      end

      it "contains some articles" do
        expect(assigns[:articles]).not_to be_nil
        expect(assigns[:articles]).not_to be_empty
      end
    end

    context "for feeds" do
      let!(:article1) { create(:article, created_at: 1.day.ago) }
      let!(:article2) { create(:article, published_at: "2004-04-01 12:00:00") }

      let(:trackback) { create(:trackback, article: article1, published_at: 1.day.ago) }

      specify "/articles.atom => an atom feed" do
        get "index", params: { format: "atom" }
        expect(response).to be_successful
        expect(response).to render_template("index_atom_feed", layout: false)
        expect(assigns(:articles)).to eq([article1, article2])
      end

      specify "/articles.rss => an RSS 2.0 feed" do
        get "index", params: { format: "rss" }
        expect(response).to be_successful
        expect(response).to render_template("index_rss_feed", layout: false)
        expect(assigns(:articles)).to eq([article1, article2])
      end

      specify "atom feed for archive should be valid" do
        get "index", params: { year: 2004, month: 4, format: "atom" }
        expect(response).to render_template("index_atom_feed", layout: false)
        expect(assigns(:articles)).to eq([article2])
      end

      specify "RSS feed for archive should be valid" do
        get "index", params: { year: 2004, month: 4, format: "rss" }
        expect(response).to render_template("index_rss_feed", layout: false)
        expect(assigns(:articles)).to eq([article2])
      end
    end

    context "with an accept header" do
      before do
        create(:article)
      end

      it "ignores the HTTP Accept: header" do
        request.env["HTTP_ACCEPT"] = "application/atom+xml"
        get "index"
        expect(response).to render_template("index")
      end
    end

    context "with blog meta keywords to 'publify, is, amazing'" do
      let!(:blog) { create(:blog, meta_keywords: "publify, is, amazing") }

      it "index without option but with blog keywords should have meta keywords" do
        get "index"
        expect(assigns(:keywords)).to eq("publify, is, amazing")
      end
    end

    context "when blog settings is empty" do
      let!(:blog) { create(:blog, settings: {}) }

      it "redirects to setup" do
        get "index"
        expect(response).to redirect_to(controller: "setup", action: "index")
      end
    end

    context "when there are no users" do
      before do
        User.destroy_all
      end

      it "redirects to signup" do
        get "index"
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end

  describe "#search" do
    let!(:blog) { create(:blog) }
    let!(:user) { create :user }

    before do
      create(:article,
             body: <<~MARKDOWN,
               in markdown format

                * we
                * use
               [ok](http://blog.ok.com) to define a link
             MARKDOWN
             text_filter_name: "markdown")
      create(:article, body: "xyz")
    end

    describe "a valid search" do
      before { get :search, params: { q: "a" } }

      it { expect(response).to render_template(:search) }
      it { expect(assigns[:articles]).not_to be_nil }
    end

    it "renders feed rss by search" do
      get "search", params: { q: "a", format: "rss" }
      expect(response).to be_successful
      expect(response).to render_template("index_rss_feed", layout: false)
    end

    it "renders feed atom by search" do
      get "search", params: { q: "a", format: "atom" }
      expect(response).to be_successful
      expect(response).to render_template("index_atom_feed", layout: false)
    end

    it "search with empty result" do
      get "search", params: { q: "abcdefghijklmnopqrstuvwxyz" }
      expect(response).to render_template("articles/error", layout: false)
    end
  end

  describe "#livesearch" do
    context "with a query with several words" do
      before do
        create(:article, body: "hello world and im herer")
        create(:article, title: "hello", body: "worldwide")
        create(:article)
        get :live_search, params: { q: "hello world" }
      end

      it "is valid" do
        expect(assigns(:articles).size).to eq(2)
      end

      it "renders without layout" do
        expect(response).to render_template(layout: nil)
      end

      it "renders template live_search" do
        expect(response).to render_template("live_search")
      end

      it "assigns @search the search string" do
        expect(assigns[:search]).to be_equal(controller.params[:q])
      end
    end
  end

  describe "#archives" do
    let(:blog) { create :blog }

    context "for an archive with several articles" do
      let!(:articles) { create_list :article, 3 }

      before do
        get "archives"
      end

      it "renders the correct template" do
        expect(response).to render_template(:archives)
      end

      it "assigns the articles" do
        expect(assigns[:articles]).to match_array articles
      end
    end
  end

  describe "#preview" do
    let!(:blog) { create(:blog) }

    context "with non logged user" do
      before do
        get :preview, params: { id: create(:article).id }
      end

      it "redirects to login" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "with logged user" do
      let(:admin) { create(:user, :as_admin) }
      let(:article) { create(:article, user: admin) }

      before do
        sign_in admin
      end

      it "assignes article define with id" do
        get :preview, params: { id: article.id }
        expect(assigns[:article]).to eq(article)
      end

      it "assignes last article with id like parent_id" do
        draft = create(:article, parent_id: article.id)
        get :preview, params: { id: article.id }
        expect(assigns[:article]).to eq(draft)
      end
    end
  end

  describe "#redirect" do
    describe "with explicit redirects" do
      describe "with empty relative_url_root" do
        it "redirects from known URL" do
          create(:blog, base_url: "http://test.host")
          create(:user)
          create(:redirect)
          get :redirect, params: { from: "foo/bar" }
          expect(response).to redirect_to("http://test.host/someplace/else")
        end

        it "does not redirect from unknown URL" do
          create(:blog, base_url: "http://test.host")
          create(:user)
          create(:redirect)
          expect { get :redirect, params: { from: "something/that/isnt/there" } }.
            to raise_error ActiveRecord::RecordNotFound
        end
      end

      # FIXME: Due to the changes in Rails 3 (no relative_url_root), this
      # does not work anymore when the accessed URL does not match the blog's
      # base_url at least partly. Do we still want to allow acces to the blog
      # through non-standard URLs? What was the original purpose of these
      # redirects?
      describe "and non-empty relative_url_root" do
        before do
          create(:blog, base_url: "http://test.host/blog")
          create(:user)
        end

        it "redirects" do
          create(:redirect, from_path: "foo/bar", to_path: "/someplace/else")
          get :redirect, params: { from: "foo/bar" }
          assert_response 301
          expect(response).to redirect_to("http://test.host/blog/someplace/else")
        end

        it "redirects if to_path includes relative_url_root" do
          create(:redirect, from_path: "bar/foo", to_path: "/blog/someplace/else")
          get :redirect, params: { from: "bar/foo" }
          assert_response 301
          expect(response).to redirect_to("http://test.host/blog/someplace/else")
        end

        it "ignores the blog base_url if the to_path is a full uri" do
          create(:redirect, from_path: "foo", to_path: "http://some.where/else")
          get :redirect, params: { from: "foo" }
          assert_response 301
          expect(response).to redirect_to("http://some.where/else")
        end
      end
    end

    it "gets good article with utf8 slug" do
      build_stubbed(:blog)
      article = create(:article, title: "ルビー",
                                 published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: "2004/06/02/ルビー" }
      expect(assigns(:article)).to eq(article)
    end

    it "gets good article with title with spaces" do
      build_stubbed(:blog)
      article = create(:article, title: "foo bar",
                                 published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: "2004/06/02/foo-bar" }
      expect(assigns(:article)).to eq(article)
    end

    it "gets good article with title with plus sign" do
      build_stubbed(:blog)
      article = create(:article, title: "foo+bar",
                                 published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: "2004/06/02/foo-bar" }
      expect(assigns(:article)).to eq(article)
    end

    # NOTE: This is needed because Rails over-unescapes glob parameters.
    it "gets good article with pre-escaped utf8 slug using unescaped slug" do
      build_stubbed(:blog)
      article = create(:article, permalink: "%E3%83%AB%E3%83%93%E3%83%BC",
                                 published_at: Time.utc(2004, 6, 2))
      get :redirect, params: { from: "2004/06/02/ルビー" }
      expect(assigns(:article)).to eq(article)
    end

    describe 'accessing old-style URL with "articles" as the first part' do
      it "redirects to article without url_root" do
        create(:blog, base_url: "http://test.host")
        article = create(:article, permalink: "second-blog-article",
                                   published_at: Time.utc(2004, 4, 1))
        get :redirect, params: { from: "articles/2004/04/01/second-blog-article" }
        assert_response 301
        expect(response).to redirect_to article.permalink_url
      end

      it "redirects to article with url_root" do
        create(:blog, base_url: "http://test.host/blog")
        create(:article, permalink: "second-blog-article", published_at: Time.utc(2004, 4,
                                                                                  1))
        get :redirect, params: { from: "articles/2004/04/01/second-blog-article" }
        assert_response 301
        expect(response).
          to redirect_to("http://test.host/blog/2004/04/01/second-blog-article")
      end

      it "redirects to article with articles in url_root" do
        create(:blog, base_url: "http://test.host/aaa/articles/bbb")
        create(:article, permalink: "second-blog-article", published_at: Time.utc(2004, 4,
                                                                                  1))
        get :redirect, params: { from: "articles/2004/04/01/second-blog-article" }
        assert_response 301
        expect(response).
          to redirect_to("http://test.host/aaa/articles/bbb/2004/04/01/second-blog-article")
      end

      it "should not redirect to an article from another blog"
    end

    describe "with permalink_format like %title%.html" do
      let!(:blog) { create(:blog, permalink_format: "/%title%.html") }
      let!(:admin) { create(:user, :as_admin) }

      before do
        sign_in admin
      end

      context "with an article" do
        let!(:article) do
          create(:article, permalink: "second-blog-article", published_at: Time.utc(2004, 4,
                                                                                    1))
        end

        context "try redirect to an unknown location" do
          it "raises RecordNotFound" do
            expect { get :redirect, params: { from: "#{article.permalink}/foo/bar" } }.
              to raise_error ActiveRecord::RecordNotFound
          end
        end

        describe "accessing legacy URLs" do
          it "redirects from default URL format" do
            get :redirect, params: { from: "2004/04/01/second-blog-article" }
            expect(response).to redirect_to article.permalink_url
          end

          it 'redirects from old-style URL format with "articles" part' do
            get :redirect, params: { from: "articles/2004/04/01/second-blog-article" }
            expect(response).to redirect_to article.permalink_url
          end
        end
      end

      describe "accessing an article" do
        let!(:article) do
          create(:article, permalink: "second-blog-article",
                           published_at: Time.utc(2004, 4, 1))
        end

        before do
          get :redirect, params: { from: "#{article.permalink}.html" }
        end

        it "renders template read to article" do
          expect(response).to render_template("articles/read")
        end

        it "assigns article1 to @article" do
          expect(assigns(:article)).to eq(article)
        end

        it "article without tags should not have meta keywords" do
          article = create(:article)
          get :redirect, params: { from: "#{article.permalink}.html" }
          expect(assigns(:keywords)).to eq("")
        end
      end

      describe "rendering as atom feed" do
        let!(:article) do
          create(:article, permalink: "second-blog-article",
                           published_at: Time.utc(2004, 4, 1))
        end
        let!(:trackback1) { create(:trackback, article: article, created_at: 1.day.ago) }

        before do
          get :redirect, params: { from: "#{article.permalink}.html.atom" }
        end

        it "renders feedback atom feed for the article" do
          expect(assigns(:article)).to eq article
          expect(response).to render_template("feedback_atom_feed", layout: false)
        end
      end

      describe "rendering as rss feed" do
        let!(:article) do
          create(:article, permalink: "second-blog-article",
                           published_at: Time.utc(2004, 4, 1))
        end
        let!(:trackback1) { create(:trackback, article: article, created_at: 1.day.ago) }

        before do
          get :redirect, params: { from: "#{article.permalink}.html.rss" }
        end

        it "renders feedback rss feed for the article" do
          expect(assigns(:article)).to eq article
          expect(response).to render_template("feedback_rss_feed", layout: false)
        end
      end
    end

    describe "with a format containing a fixed component" do
      let!(:blog) { create(:blog, permalink_format: "/foo/%title%") }
      let!(:article) { create(:article) }

      it "finds the article if the url matches all components" do
        get :redirect, params: { from: "foo/#{article.permalink}" }
        expect(response).to be_successful
      end

      it "does not find the article if the url does not match the fixed component" do
        expect { get :redirect, params: { from: "bar/#{article.permalink}" } }.
          to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
