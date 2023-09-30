# frozen_string_literal: true

require "rails_helper"

# Test article rendering for installed themes
RSpec.describe ArticlesController, type: :controller do
  render_views

  with_each_theme do |theme, _view_path|
    context "with theme #{theme}" do
      let!(:blog) { create(:blog, theme: theme) }

      describe "#redirect" do
        let(:article) { create(:article) }
        let(:from_param) { article.permalink_url.sub(%r{#{blog.base_url}/}, "") }

        it "successfully renders an article" do
          get :redirect, params: { from: from_param }
          expect(response).to be_successful
        end

        context "when the article has an excerpt" do
          let(:article) { create(:article, excerpt: "foo", body: "bar") }

          it "does not render a continue reading link" do
            get :redirect, params: { from: from_param }

            aggregate_failures do
              expect(response.body).to have_text "bar"
              expect(response.body).not_to have_text "foo"
              expect(response.body).
                not_to have_text I18n.t!("articles.article_excerpt.continue_reading")
            end
          end
        end

        describe "accessing an article" do
          let!(:article) { create(:article) }

          before do
            get :redirect, params: { from: from_param }
          end

          it "has good rss feed link" do
            expect(response.body).
              to have_selector("head>link[href=\"#{article.permalink_url}.rss\"]",
                               visible: :all)
          end

          it "has good atom feed link" do
            expect(response.body).
              to have_selector("head>link[href=\"#{article.permalink_url}.atom\"]",
                               visible: :all)
          end

          it "has a canonical url" do
            expect(response.body).
              to have_selector("head>link[href='#{article.permalink_url}']",
                               visible: :all)
          end

          it "has a good title" do
            expect(response.body).
              to have_css("title", text: "A big article | test blog",
                                   visible: :all)
          end
        end

        describe "theme rendering" do
          let!(:article) { create(:article) }

          it "renders without errors when no comments or trackbacks are present" do
            get :redirect, params: { from: from_param }
            expect(response).to be_successful
          end

          it "renders without errors when recaptcha is enabled" do
            Recaptcha.configure do |config|
              config.site_key = "YourAPIkeysHere_yyyyyyyyyyyyyyyyy"
              config.secret_key = "YourAPIkeysHere_xxxxxxxxxxxxxxxxx"
            end
            blog.use_recaptcha = true
            blog.save!
            get :redirect, params: { from: from_param }
            expect(response).to be_successful
          end

          it "renders without errors when comments and trackbacks are present" do
            create(:trackback, article: article)
            create(:comment, article: article)
            get :redirect, params: { from: from_param }
            expect(response).to be_successful
          end
        end

        context "when the article is password protected" do
          let(:article) do
            create(:article, title: "Secretive", body: "protected foobar",
                             password: "password")
          end

          it "shows a password form for the article" do
            get :redirect, params: { from: from_param }
            expect(response.body).to have_field "article_password"
          end

          it "does not include the article body anywhere" do
            get :redirect, params: { from: from_param }
            expect(response.body).not_to include article.body
          end
        end
      end

      describe "#index" do
        let!(:user) { create(:user) }

        context "without any parameters" do
          let!(:article) { create(:article) }
          let!(:note) { create(:note) }

          before do
            get :index
          end

          it "has good link feed rss" do
            expect(response.body).
              to have_css('head>link[href="http://test.host/articles.rss"]',
                          visible: :all)
          end

          it "has good link feed atom" do
            expect(response.body).
              to have_css('head>link[href="http://test.host/articles.atom"]',
                          visible: :all)
          end

          it "has a canonical url" do
            expect(response.body).
              to have_selector("head>link[href='#{blog.base_url}/']", visible: :all)
          end

          it "has good title" do
            expect(response.body).
              to have_css("title", text: "test blog | test subtitle", visible: :all)
          end
        end

        context "when an article has an excerpt" do
          let!(:article) { create(:article, excerpt: "foo", body: "bar") }

          it "renders a continue reading link" do
            get :index

            aggregate_failures do
              expect(response.body).not_to have_text "bar"
              expect(response.body).to have_text "foo"
              expect(response.body).
                to have_text I18n.t!("articles.article_excerpt.continue_reading")
            end
          end
        end

        context "when requesting archives for a month" do
          before do
            create(:article, published_at: Time.utc(2004, 4, 23))
            get "index", params: { year: 2004, month: 4 }
          end

          it "has a canonical url" do
            expect(response.body).
              to have_selector("head>link[href='#{blog.base_url}/2004/4']",
                               visible: :all)
          end

          it "has a good title" do
            expect(response.body).
              to have_css("title", text: "Archives for test blog", visible: :all)
          end
        end
      end

      describe "#search", "with a markdown formatted article" do
        let!(:user) { create(:user) }

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
          get :search, params: { q: "a" }
        end

        it "renders content with markdown interpreted and html tags removed" do
          expect(response.body).
            to have_css(
              "div", text: /in markdown format\s+we\s+use\s+ok to define a link/)
        end
      end

      describe "#search" do
        render_views

        let!(:blog) { create(:blog) }
        let!(:user) { create(:user) }
        let!(:matching_article) { create(:article, body: "public foobar") }
        let!(:not_matching_article) { create(:article, body: "barbaz") }
        let!(:protected_article) do
          create(:article, body: "protected foobar", password: "secret!")
        end

        it "renders result with only matching articles" do
          get :search, params: { q: "oba" }

          aggregate_failures do
            expect(response).to render_template(:search)
            expect(assigns[:articles]).
              to contain_exactly matching_article, protected_article
            expect(response.body).to have_text "public foobar"
            expect(response.body).not_to have_text "protected foobar"
          end
        end

        it "has good rss feed link" do
          get :search, params: { q: "oba" }

          expect(response.body).
            to have_css('head>link[href="http://test.host/search/oba.rss"]',
                        visible: :all)
        end

        it "has good atom feed link" do
          get :search, params: { q: "oba" }

          expect(response.body).
            to have_css('head>link[href="http://test.host/search/oba.atom"]',
                        visible: :all)
        end

        it "has a canonical url" do
          get :search, params: { q: "oba" }

          expect(response.body).
            to have_selector("head>link[href='#{blog.base_url}/search/oba']",
                             visible: :all)
        end

        it "has a good title" do
          get :search, params: { q: "oba" }

          expect(response.body).
            to have_css("title", text: "Results for oba | test blog",
                                 visible: :all)
        end

        it "renders feed rss by search" do
          get "search", params: { q: "oba", format: "rss" }
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to render_template("index_rss_feed", layout: false)
            expect(response.body).to have_text "public foobar"
            expect(response.body).not_to have_text "protected foobar"
          end
        end

        it "renders feed atom by search" do
          get "search", params: { q: "oba", format: "atom" }
          aggregate_failures do
            expect(response).to be_successful
            expect(response).to render_template("index_atom_feed", layout: false)
            expect(response.body).to have_text "public foobar"
            expect(response.body).not_to have_text "protected foobar"
          end
        end

        it "search with empty result" do
          get "search", params: { q: "abcdefghijklmnopqrstuvwxyz" }
          expect(response).to render_template("articles/error", layout: false)
          expect(assigns[:articles]).to eq []
        end
      end

      describe "#livesearch" do
        before do
          create(:article, body: "hello world and im herer")
          create(:article, title: "hello", body: "worldwide")
          create(:article)
          get :live_search, params: { q: "hello world" }
        end

        it "does not have h3 tag" do
          expect(response.body).to have_css("h3")
        end
      end

      describe "#archives" do
        context "with several articles" do
          let!(:articles) { create_list(:article, 3) }

          before do
            get "archives"
          end

          it "has the correct self-link and title" do
            expect(response.body).
              to have_selector("head>link[href='#{blog.base_url}/archives']",
                               visible: :all).
              and have_css("title", text: "Archives for test blog", visible: :all)
          end

          it "shows the current month only once" do
            expect(response.body).
              to have_css("h3", count: 1).
              and have_text I18n.l(articles.first.published_at,
                                   format: :letters_month_with_year)
          end
        end

        context "with an article with tags" do
          it "renders correctly" do
            create(:article, keywords: "foo, bar")
            get "archives"

            expect(response.body).to have_text "foo"
            expect(response.body).to have_text "bar"
          end
        end
      end

      describe "#preview" do
        context "with logged user" do
          let(:admin) { create(:user, :as_admin) }
          let(:article) { create(:article, user: admin) }

          before do
            sign_in admin
          end

          it "renders the regular read template" do
            get :preview, params: { id: article.id }
            expect(response).to render_template("articles/read")
          end

          context "when the article has an excerpt" do
            let(:article) { create(:article, excerpt: "foo", body: "bar", user: admin) }

            it "does not render a continue reading link" do
              get :preview, params: { id: article.id }

              aggregate_failures do
                expect(response.body).to have_text "bar"
                expect(response.body).not_to have_text "foo"
                expect(response.body).
                  not_to have_text I18n.t!("articles.article_excerpt.continue_reading")
              end
            end
          end
        end
      end

      describe "#check_password" do
        let!(:article) { create(:article, password: "password") }

        it "shows article when given correct password" do
          post :check_password, xhr: true,
                                params: { article: { id: article.id,
                                                     password: article.password } }
          expect(response.body).not_to have_field "article_password"
        end

        it "shows password form when given incorrect password" do
          post :check_password, xhr: true,
                                params: { article: { id: article.id,
                                                     password: "wrong password" } }
          expect(response.body).to have_field "article_password"
        end
      end
    end
  end
end
