# frozen_string_literal: true

require "rails_helper"

describe CommentsController, type: :controller do
  let!(:blog) { create(:blog) }
  let(:article) { create(:article) }
  let(:comment_params) do
    { body: "content", author: "bob", email: "bob@home", url: "http://bobs.home/" }
  end

  describe "#create" do
    context "when using regular post" do
      before do
        post :create, params: { comment: comment_params, article_id: article.id }
      end

      it "creates a comment on the specified article" do
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
        aggregate_failures do
          expect(cookies["author"]).to eq("bob")
          expect(cookies["gravatar_id"]).to eq(Digest::MD5.hexdigest("bob@home"))
          expect(cookies["url"]).to eq("http://bobs.home/")
        end
      end

      it "redirects to the article" do
        expect(response).to redirect_to article.permalink_url
      end
    end

    context "when using xhr post" do
      before do
        post :create, xhr: true, params: { comment: comment_params, article_id: article.id }
      end

      it "assigns the created comment for rendering" do
        expect(assigns[:comment]).to eq article.comments.last
      end

      it "renders the comment partial" do
        expect(response).to render_template("articles/comment")
      end
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
