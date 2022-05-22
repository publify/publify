# frozen_string_literal: true

require "rails_helper"

describe Admin::ContentController, type: :controller do
  render_views

  before do
    create :blog
  end

  describe "index" do
    let(:publisher) { create(:user, :as_publisher) }
    let!(:article) { create(:article) }

    before do
      sign_in publisher
    end

    context "simple query" do
      before { get :index }

      it { expect(response).to be_successful }
      it { expect(response).to render_template("index", layout: "administration") }
    end

    it "return article that match with search query" do
      get :index, params: { search: { searchstring: article.body[0..4] } }
      expect(assigns(:articles)).to eq([article])
    end

    it "search query and limit on published_at" do
      get :index, params: { search: {
        searchstring: article.body[0..4],
        published_at: article.published_at + 2.days,
      } }
      expect(assigns(:articles)).to be_empty
    end

    context "search for state" do
      let!(:draft_article) { create(:article, state: "draft") }
      let!(:pending_article) do
        create(:article, state: "publication_pending", published_at: "2020-01-01")
      end

      it "returns draft articles when drafts is specified" do
        get :index, params: { search: { state: "drafts" } }

        expect(assigns(:articles)).to eq([draft_article])
      end

      it "returns pending articles when pending is specified" do
        get :index, params: { search: { state: "pending" } }

        expect(assigns(:articles)).to eq([pending_article])
      end

      it "returns all states when called with a bad state" do
        get :index, params: { search: { state: "3vI1 1337 h4x0r" } }

        expect(assigns(:articles).sort).
          to eq([article, pending_article, draft_article].sort)
      end
    end
  end

  describe "#autosave" do
    let(:publisher) { create(:user, :as_publisher) }

    before do
      sign_in publisher
    end

    context "first time save" do
      it "creates a new draft Article" do
        expect do
          post :autosave, xhr: true, params: { article: attributes_for(:article) }
        end.to change(Article, :count).by(1)
      end

      it "creates tags for the draft article if relevant" do
        expect do
          post :autosave,
               xhr: true, params: { article: attributes_for(:article, :with_tags) }
        end.to change(Tag, :count).by(2)
      end
    end

    context "second call to save" do
      let!(:draft) { create(:article, state: "draft") }

      it "does not create an extra draft" do
        expect do
          post :autosave,
               xhr: true, params: { article: { id: draft.id,
                                               body_and_extended: "new body" } }
        end.not_to change(Article, :count)
      end
    end

    context "with an other existing draft" do
      let!(:draft) { create(:article, state: "draft", body: "existing body") }

      it "creates a new draft Article" do
        expect do
          post :autosave, xhr: true, params: { article: attributes_for(:article) }
        end.to change(Article, :count).by(1)
      end

      it "does not replace existing draft" do
        post :autosave, xhr: true, params: { article: attributes_for(:article) }
        expect(assigns(:article).id).not_to eq(draft.id)
        expect(assigns(:article).body).not_to eq(draft.body)
      end
    end
  end

  describe "#new" do
    let(:publisher) { create(:user, :as_publisher) }

    before do
      sign_in publisher
      get :new
    end

    it { expect(response).to be_successful }
    it { expect(response).to render_template("new") }
    it { expect(assigns(:article)).not_to be_nil }
    it { expect(assigns(:article).redirect).to be_nil }
  end

  describe "#create" do
    shared_examples_for "create action" do
      def base_article(options = {})
        { title: "posted via tests!",
          body: "A good body",
          allow_comments: "1",
          allow_pings: "1" }.merge(options)
      end

      it "sends notifications on create" do
        u = create(:user, notify_via_email: true, notify_on_new_articles: true)
        u.save!
        ActionMailer::Base.deliveries.clear
        emails = ActionMailer::Base.deliveries

        post :create, params: { "article" => base_article }

        assert_equal(1, emails.size)
        assert_equal(u.email, emails.first.to[0])
      end

      it "creates an article with tags" do
        post :create, params: { "article" => base_article(keywords: "foo bar") }
        new_article = Article.last
        assert_equal 2, new_article.tags.size
      end

      it "creates an article with a password" do
        post :create, params: { "article" => base_article(password: "foobar") }
        new_article = Article.last
        expect(new_article.password).to eq("foobar")
      end

      it "creates an article with a unique Tag instance named lang:FR" do
        post :create, params: { "article" => base_article(keywords: "lang:FR") }
        new_article = Article.last
        expect(new_article.tags.map(&:name)).to include("lang-fr")
      end

      it "interprets time zone in :published_at correctly" do
        article = base_article(published_at: "February 17, 2011 08:47 PM GMT+0100 (CET)")
        post :create, params: { article: article }
        new_article = Article.last
        assert_equal Time.utc(2011, 2, 17, 19, 47), new_article.published_at
      end

      it 'respects "GMT+0000 (UTC)" in :published_at' do
        article = base_article(published_at: "August 23, 2011 08:40 PM GMT+0000 (UTC)")
        post :create, params: { article: article }
        new_article = Article.last
        assert_equal Time.utc(2011, 8, 23, 20, 40), new_article.published_at
      end

      it "creates a filtered article" do
        Article.delete_all
        body = "body via *markdown*"
        extended = "*foo*"
        post :create,
             params: { article: { title: "another test", body: body, extended: extended } }

        assert_response :redirect, action: "index"

        new_article = Article.order(created_at: :desc).first

        expect(new_article.body).to eq body
        expect(new_article.extended).to eq extended
        expect(new_article.text_filter.name).to eq "markdown smartypants"
        expect(new_article.html(:body)).to eq "<p>body via <em>markdown</em></p>"
        expect(new_article.html(:extended)).to eq "<p><em>foo</em></p>"
      end

      context "with a previously autosaved draft" do
        before do
          @draft = create(:article, body: "draft", state: "draft")
          post :create,
               params: { article: { id: @draft.id, body: "update", published: true } }
        end

        it "updates the draft" do
          expect(Article.find(@draft.id).body).to eq "update"
        end

        it "makes the draft published" do
          expect(Article.find(@draft.id)).to be_published
        end
      end

      describe "with an unrelated draft in the database" do
        before do
          @draft = create(:article, state: "draft")
        end

        describe "saving new article as draft" do
          it "leaves the original draft in existence" do
            post :create, params: { article: base_article(draft: "save as draft") }
            expect(assigns(:article).id).not_to eq(@draft.id)
            expect(Article.find(@draft.id)).not_to be_nil
          end
        end
      end
    end

    context "as a publisher" do
      let(:publisher) { create(:user, :as_publisher) }
      let(:article_params) { { title: "posted via tests!", body: "a good boy" } }

      before do
        sign_in publisher
        @user = publisher
      end

      it "creates an article" do
        expect do
          post :create, params: { article: article_params }
        end.to change(Article, :count).by(1)
      end

      context "classic" do
        before { post :create, params: { article: article_params } }

        it { expect(response).to redirect_to(action: :index) }
        it { expect(flash[:success]).to eq(I18n.t("admin.content.create.success")) }

        it { expect(assigns(:article)).to be_published }
        it { expect(assigns(:article).user).to eq(publisher) }

        context "when doing a draft" do
          let(:article_params) do
            { title: "posted via tests!", body: "a good boy", draft: "true" }
          end

          it { expect(assigns(:article)).not_to be_published }
        end
      end

      context "writing for the future" do
        let(:article_params) do
          { title: "posted via tests!", body: "a good boy",
            published_at: 1.hour.from_now.to_s }
        end

        before do
          post :create, params: { article: article_params }
        end

        it "does not create a short url" do
          expect(Redirect.count).to eq 0
        end

        it "creates a trigger to publish the article" do
          expect(Trigger.count).to eq 1
        end

        it "does not publish the article" do
          expect(assigns(:article)).to be_publication_pending
        end

        it "sets the publication time in the future" do
          expect(assigns(:article).published_at).to be > 10.minutes.from_now
        end
      end
    end

    context "as an admin" do
      let(:admin) { create(:user, :as_admin) }

      before do
        sign_in admin
        @user = admin
      end

      it_behaves_like "create action"
    end
  end

  describe "#edit" do
    context "as an admin" do
      let(:admin) { create(:user, :as_admin) }
      let(:article) { create(:article) }

      before do
        sign_in admin
      end

      it "edits article" do
        get :edit, params: { "id" => article.id }
        expect(response).to render_template "edit"
        expect(assigns(:article)).not_to be_nil
        expect(assigns(:article)).to be_valid
        expect(response.body).to match(/body/)
        expect(response.body).to match(/extended content/)
      end

      it "correctly converts multi-word tags" do
        a = create(:article, keywords: '"foo bar", baz')
        get :edit, params: { id: a.id }
        expect(response.body).
          to have_selector("input[id=article_keywords][value='baz, \"foo bar\"']")
      end
    end

    context "as a publisher" do
      let(:publisher) { create(:user, :as_publisher) }

      before do
        sign_in publisher
      end

      context "with an article from an other user" do
        let(:article) { create(:article, user: create(:user, login: "another_user")) }

        before { get :edit, params: { id: article.id } }

        it { expect(response).to redirect_to(action: "index") }
      end

      context "with an article from current user" do
        let(:article) { create(:article, user: publisher) }

        before { get :edit, params: { id: article.id } }

        it { expect(response).to render_template("edit") }
        it { expect(assigns(:article)).not_to be_nil }
        it { expect(assigns(:article)).to be_valid }
      end
    end
  end

  describe "#update" do
    context "as an admin" do
      let(:admin) { create(:user, :as_admin) }
      let(:article) { create(:article) }

      before do
        sign_in admin
      end

      it "updates article" do
        emails = ActionMailer::Base.deliveries
        emails.clear

        art_id = article.id

        body = "another *textile* test"
        put :update, params: { id: art_id,
                               article: { body: body, text_filter_name: "textile" } }
        assert_response :redirect, action: "show", id: art_id

        article.reload
        expect(article.text_filter.name).to eq("textile")
        expect(body).to eq(article.body)

        expect(emails.size).to eq(0)
      end

      it "allows updating body_and_extended" do
        put :update, params: { "id" => article.id, "article" => {
          "body_and_extended" => "foo<!--more-->bar<!--more-->baz",
        } }
        assert_response :redirect
        article.reload
        expect(article.body).to eq("foo")
        expect(article.extended).to eq("bar<!--more-->baz")
      end

      it "allows updating password" do
        put :update, params: { "id" => article.id, "article" => {
          "password" => "foobar",
        } }
        assert_response :redirect
        article.reload
        expect(article.password).to eq("foobar")
      end

      context "when a published article has drafts" do
        let(:original_published_at) { 2.days.ago.to_date }
        let!(:original) { create(:article, published_at: original_published_at) }
        let!(:draft) { create(:article, parent_id: original.id, state: "draft") }
        let!(:second_draft) { create(:article, parent_id: original.id, state: "draft") }

        describe "publishing the published article" do
          before do
            put(:update, params: {
                  id: original.id,
                  article: { id: draft.id, body: "update" },
                })
          end

          it "updates the article" do
            expect(original.reload.body).to eq "update"
          end

          it "deletes all drafts" do
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(draft.id)
            end
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(second_draft.id)
            end
          end

          it "keeps the original publication date" do
            expect(original.reload.published_at).to eq original_published_at
          end
        end

        describe "publishing a draft copy of the published article" do
          before do
            put(:update, params: {
                  id: draft.id,
                  article: { id: draft.id, body: "update" },
                })
          end

          it "updates the original" do
            expect(original.reload.body).to eq("update")
          end

          it "deletes all drafts" do
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(draft.id)
            end
            assert_raises ActiveRecord::RecordNotFound do
              Article.find(second_draft.id)
            end
          end

          it "keeps the original publication date" do
            expect(original.reload.published_at).to eq original_published_at
          end
        end

        describe "publishing a draft copy with a new publication date" do
          before do
            put(:update, params: {
                  id: draft.id,
                  article: { id: draft.id, body: "update", published_at: "2016-07-07" },
                })
          end

          it "updates the original publication date" do
            expect(original.reload.published_at).to eq Date.new(2016, 7, 7)
          end
        end
      end

      describe "saving a published article as draft" do
        before do
          @orig = create(:article)
          put(:update, params: {
                id: @orig.id,
                article: { title: @orig.title, draft: "draft", body: "update" },
              })
        end

        it "leaves the original published" do
          @orig.reload
          expect(@orig).to be_published
        end

        it "leaves the original as is" do
          @orig.reload
          expect(@orig.body).not_to eq("update")
        end

        it "redirects to the index" do
          expect(response).to redirect_to(action: "index")
        end

        it "creates a draft" do
          draft = Article.child_of(@orig.id).first
          expect(draft.parent_id).to eq(@orig.id)
          expect(draft).not_to be_published
        end
      end
    end

    context "as a publisher" do
      let(:publisher) { create(:user, :as_publisher) }

      before do
        sign_in publisher
      end

      context "with an article" do
        let(:article) { create(:article, body: "another *textile* test", user: publisher) }
        let(:body) { "not the *same* text" }

        before do
          put :update,
              params: { id: article.id,
                        article: { body: body, text_filter_name: "textile" } }
        end

        it { expect(response).to redirect_to(action: "index") }
        it { expect(article.reload.text_filter.name).to eq("textile") }
        it { expect(article.reload.body).to eq(body) }
      end

      context "with an owned article and another user's article" do
        let(:article) { create(:article, body: "another *textile* test", user: publisher) }
        let(:other_article) { create(:article, body: "other article") }
        let(:body) { "not the *same* text" }

        before do
          put :update,
              params: { id: article.id,
                        article: { id: other_article.id, body: body } }
        end

        it "ignores the extra id passed in the article parameters" do
          aggregate_failures do
            expect(response).to redirect_to(action: "index")
            expect(article.reload.body).to eq(body)
            expect(other_article.reload.body).not_to eq(body)
          end
        end
      end
    end
  end

  describe "#auto_complete_for_article_keywords" do
    let(:publisher) { create(:user, :as_publisher) }

    before do
      sign_in publisher
    end

    before do
      create(:tag, name: "foo", contents: [create(:article)])
      create(:tag, name: "bazz", contents: [create(:article)])
      create(:tag, name: "bar", contents: [create(:article)])
    end

    it "returns foo for keywords fo" do
      get :auto_complete_for_article_keywords, params: { article: { keywords: "fo" } }
      expect(response).to be_successful
      expect(response.body).to eq('["bar","bazz","foo"]')
    end
  end

  describe "#destroy" do
    let(:publisher) { create(:user, :as_publisher) }

    before do
      sign_in publisher
    end

    context "with an article from other user" do
      let(:article) { create(:article, user: create(:user, login: "other_user")) }

      before { delete :destroy, params: { id: article.id } }

      it { expect(response).to redirect_to(action: "index") }
      it { expect(Article.count).to eq(1) }
    end

    context "with an article from user" do
      let(:article) { create(:article, user: publisher) }

      before { delete :destroy, params: { id: article.id } }

      it { expect(response).to redirect_to(action: "index") }
      it { expect(Article.count).to eq(0) }
    end
  end
end
