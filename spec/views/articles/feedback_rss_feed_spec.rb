require 'spec_helper'

describe "articles/feedback_rss_feed.rss.builder" do
  before do
    stub_default_blog
  end

  describe "rendering trackbacks" do
    let(:article) { stub_full_article }
    let(:trackback) { Factory.build(:trackback, :article => article) }

    it "should render a valid rss feed" do
      assign(:feedback, [trackback])
      render
      assert_feedvalidator rendered
      assert_rss20 rendered, 1
    end
  end
end

