require 'rails_helper'

describe 'comments/index_rss_feed.rss.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering comments' do
    let(:article) { FactoryGirl.build_stubbed :article }
    let(:comment) { FactoryGirl.build_stubbed(:comment, article: article, body: 'Comment body', guid: '12313123123123123') }

    before(:each) do
      assign(:items, [comment])
      render
    end

    it 'should render a valid rss feed' do
      assert_rss20 rendered, 1
    end

    describe 'the comment entry' do
      it 'should have all the required attributes' do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css('item').first

        expect(entry_xml.css('title').first.content).to eq(
          "Comment on #{article.title} by #{comment.author}"
        )
        expect(entry_xml.css('guid').first.content).to eq('urn:uuid:12313123123123123')
        expect(entry_xml.css('description').first.content).to eq('<p>Comment body</p>')
        expect(entry_xml.css('link').first.content).to eq("#{article.permalink_url}#comment-#{comment.id}")
      end
    end
  end
end
