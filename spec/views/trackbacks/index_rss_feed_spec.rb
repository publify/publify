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

    it 'should render a valid rss feed' do
      assert_rss20 rendered, 1
    end

    describe 'the trackback entry' do
      it 'should have all the required attributes' do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css('item').first

        expect(entry_xml.css('title').first.content).to eq(
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        )
        expect(entry_xml.css('guid').first.content).to eq('urn:uuid:dsafsadffsdsf')
        expect(entry_xml.css('description').first.content).to eq('This is an excerpt')
        expect(entry_xml.css('link').first.content).to eq(trackback.url)
      end
    end
  end
end
