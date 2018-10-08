# frozen_string_literal: true

require 'rails_helper'

describe 'articles/feedback_rss_feed.rss.builder', type: :view do
  let(:article) { create :article }

  describe 'with feedback consisting of one trackback and one comment' do
    let!(:trackback) { create(:trackback, article: article) }
    let!(:comment) { create(:comment, article: article, body: 'Comment body') }
    let(:parsed_feed) { Feedjira::Feed.parse(rendered) }

    before do
      assign(:article, article)
      render
    end

    it 'renders a valid RSS feed with two items' do
      assert_rss20_feed parsed_feed, 2
    end

    it 'renders the correct RSS partials' do
      expect(view).
        to render_template(partial: 'shared/_rss_item_trackback', count: 1).
        and render_template(partial: 'shared/_rss_item_comment', count: 1)
    end

    it 'links to the article url' do
      expect(parsed_feed.url).to eq article.permalink_url
    end
  end
end
