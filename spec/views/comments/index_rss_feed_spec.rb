require 'rails_helper'

describe 'comments/index_rss_feed.rss.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering comments' do
    let(:article) { build_stubbed :article }
    let(:comment) { build_stubbed(:comment, article: article, body: 'Comment body', guid: '12313123123123123') }

    before(:each) do
      assign(:items, [comment])
      render
    end

    it 'renders a valid rss feed with one entry' do
      assert_rss20 rendered, 1
    end

    describe 'the comment entry' do
      let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }
      let(:xml_entry) { Nokogiri::XML.parse(rendered).css('item').first }

      it 'should have all the required attributes' do
        expect(rendered_entry.title).to eq "Comment on #{article.title} by #{comment.author}"
        expect(rendered_entry.entry_id).to eq('urn:uuid:12313123123123123')
        expect(rendered_entry.summary).to eq('<p>Comment body</p>')
        expect(xml_entry.css('link').first.content).to eq("#{article.permalink_url}#comment-#{comment.id}")
      end
    end
  end
end
