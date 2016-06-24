require 'rails_helper'

describe 'articles/feedback_atom_feed.atom.builder', type: :view do
  let!(:blog) { create :blog }

  describe 'with one trackback' do
    let(:article) { stub_full_article }
    let(:trackback) { build(:trackback, article: article) }

    before(:each) do
      assign(:feedback, [trackback])
      render
    end

    it 'renders a valid Atom feed with one item' do
      assert_atom10 rendered, 1
    end

    describe 'the trackback entry' do
      it 'should have all the required attributes' do
        entry_xml = Feedjira::Feed.parse(rendered).entries.first

        expect(entry_xml.title).to eq(
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        )
        expect(entry_xml.entry_id).to eq('urn:uuid:dsafsadffsdsf')
      end
    end
  end

  describe 'with a comment with problematic characters' do
    let(:article) { stub_full_article }
    let(:comment) { build(:comment, article: article, body: '&eacute;coute! 4 < 2, non?') }

    before(:each) do
      assign(:feedback, [comment])
      render
    end

    it 'renders a valid Atom feed with one item' do
      assert_atom10 rendered, 1
    end
  end
end
