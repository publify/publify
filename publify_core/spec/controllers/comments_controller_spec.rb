# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:blog) { create(:blog) }
  let(:article) { create(:article) }
  let(:user) { create(:user) }
  let(:comment_params) do
    { body: "content", author: "bob", email: "bob@home", url: "http://bobs.home/" }
  end

  describe "#create" do
    render_views

    it "creates a comment on the specified article" do
      post :create, params: { comment: comment_params, article_id: article.id }
      aggregate_failures do
        expect(article.comments.size).to eq(1)
        comment = article.comments.last
        expect(comment.author).to eq("bob")
        expect(comment.body).to eq("content")
        expect(comment.email).to eq("bob@home")
        expect(comment.url).to eq("http://bobs.home/")
      end
    end

    it "remembers author info in cookies" do
      post :create, params: { comment: comment_params, article_id: article.id }
      aggregate_failures do
        expect(cookies["author"]).to eq("bob")
        expect(cookies["gravatar_id"]).to eq(Digest::MD5.hexdigest("bob@home"))
        expect(cookies["url"]).to eq("http://bobs.home/")
      end
    end

    it "sets the user if logged in" do
      sign_in user
      post :create, params: { comment: comment_params, article_id: article.id }
      comment = article.comments.last
      expect(comment.user).to eq user
    end

    it "assigns the created comment" do
      post :create, params: { comment: comment_params, article_id: article.id }
      expect(assigns[:comment]).to eq article.comments.last
    end

    it "redirects to the article when using regular post" do
      post :create, params: { comment: comment_params, article_id: article.id }
      expect(response).to redirect_to article.permalink_url
    end

    it "renders the comment when using xhr post" do
      post :create, xhr: true, params: { comment: comment_params, article_id: article.id }
      aggregate_failures do
        expect(response).to render_template("articles/comment")
        expect(response.body).to have_text "content"
      end
    end

    it "does not allow commenting if article does not allow comments" do
      no_comments = create(:article, allow_comments: false)
      expect do
        post :create, xhr: true, params: { comment: comment_params,
                                           article_id: no_comments.id }
      end.not_to change(no_comments.comments, :count)
    end

    it "does not allow commenting if article is draft" do
      draft = create(:article, state: "draft")
      expect do
        post :create, xhr: true, params: { comment: comment_params, article_id: draft.id }
      end.not_to change(draft.comments, :count)
    end
  end

  describe "#preview" do
    context "when using xhr post" do
      before do
        post :preview, xhr: true, params: { comment: comment_params,
                                            article_id: article.id }
      end

      it "assigns a comment with the given parameters" do
        comment = assigns[:comment]
        aggregate_failures do
          expect(comment.author).to eq("bob")
          expect(comment.body).to eq("content")
          expect(comment.email).to eq("bob@home")
          expect(comment.url).to eq("http://bobs.home/")
        end
      end

      it "assigns the article to the comment" do
        expect(assigns[:comment].article).to eq article
      end
    end
  end
end
