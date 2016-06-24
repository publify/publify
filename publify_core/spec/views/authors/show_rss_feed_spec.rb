require 'rails_helper'

describe 'authors/show_rss_feed.rss.builder', type: :view do
  let!(:blog) { create(:blog) }

  describe 'rendering articles (with some funny characters)' do
    before(:each) do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])
      render
    end

    it 'create a valid RSS feed with two items' do
      assert_rss20 rendered, 2
    end

    it 'renders the article RSS partial twice' do
      expect(view).to render_template(partial: 'shared/_rss_item_article', count: 2)
    end
  end
end
