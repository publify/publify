require 'spec_helper'

describe "articles/index_rss_feed.rss.builder" do
  before do
    stub_default_blog
  end

  describe "rendering articles" do
    it 'should create valid rss feed when articles contains funny bits' do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])

      render

      assert_rss20 rendered, 2
      assert_feedvalidator rendered
    end
  end
end

