require 'spec_helper'

describe "articles/feedback_rss_feed.rss.builder" do
  let!(:blog) { build_stubbed :blog }

  describe "with feedback consisting of one trackback and one comment" do
    let(:article) { stub_full_article }
    let(:trackback) { build(:trackback, :article => article) }
    let(:comment) { build(:comment, :article => article, :body => "Comment body") }

    before(:each) do
      assign(:feedback, [trackback, comment])
      render
    end

    it "renders a valid feed" do
      assert_feedvalidator rendered
    end

    it "renders an RSS feed with two items" do
      assert_rss20 rendered, 2
    end

    it "renders the trackback RSS partial once" do
      view.should render_template(:partial => "shared/_rss_item_trackback", :count => 1)
    end

    it "renders the comment RSS partial once" do
      view.should render_template(:partial => "shared/_rss_item_comment", :count => 1)
    end
  end
end

