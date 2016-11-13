require 'rails_helper'

describe 'trackbacks/index_rss_feed.rss.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering trackbacks' do
    let(:article) { stub_full_article }
    let(:trackback) { FactoryGirl.build(:trackback, article: article) }

    before(:each) do
      assign(:items, [trackback])
      render
    end

    it 'renders a valid rss feed with one entry' do
      assert_rss20 rendered, 1
    end

    describe 'the trackback entry' do
      let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }
      let(:xml_entry) { Nokogiri::XML.parse(rendered).css('item').first }

      it 'should have all the required attributes' do
        expect(rendered_entry.title).to eq "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        expect(rendered_entry.entry_id).to eq('urn:uuid:dsafsadffsdsf')
        expect(rendered_entry.summary).to eq('This is an excerpt')
        expect(xml_entry.css('link').first.content).to eq(trackback.url)
      end
    end
  end
end
