require 'spec_helper'

describe "authors/show_rss_feed.rss.builder" do
  before do
    stub_default_blog
  end

  describe "rendering articles (with some funny characters)" do
    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])

      render
    end

    it "creates a valid feed" do
      assert_feedvalidator rendered
    end

    it "creates an RSS feed with two items" do
      assert_rss20 rendered, 2
    end

    it "renders the article RSS partial twice" do
      view.should render_template(:partial => "shared/_rss_item_article",
                                  :count => 2)
    end
  end
end


