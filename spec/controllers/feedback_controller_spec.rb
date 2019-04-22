# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackController, type: :controller do
  render_views

  describe "index" do
    let!(:items) do
      [
        create(:comment, state: :presumed_ham),
        create(:comment),
        create(:trackback, title: "some"),
        create(:trackback, title: "items"),
      ]
    end

    let!(:spammy_items) do
      [
        create(:spam_comment),
        create(:trackback, state: "spam"),
      ]
    end

    context "with atom format" do
      before { get "index", params: { format: "atom" } }

      it "renders a valid atom feed with 4 items" do
        assert_atom10 response.body, 4
      end

      it "renders each item with the correct template" do
        expect(response).
          to render_template(partial: "shared/_atom_item_comment", count: 2).
          and render_template(partial: "shared/_atom_item_trackback", count: 2)
      end
    end

    context "with rss format" do
      before { get "index", params: { format: "rss" } }

      it "renders a valid rss feed with 4 items" do
        assert_rss20 response.body, 4
      end

      it "renders each item with the correct template" do
        expect(response).
          to render_template(partial: "shared/_rss_item_comment", count: 2).
          and render_template(partial: "shared/_rss_item_trackback", count: 2)
      end
    end
  end
end
