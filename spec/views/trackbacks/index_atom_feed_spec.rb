require 'rails_helper'

describe 'trackbacks/index_atom_feed.atom.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering trackbacks with one trackback' do
    let(:article) { build_stubbed(:article) }
    let(:trackback) { build_stubbed(:trackback, article: article) }

    before(:each) do
      assign(:items, [trackback])
      render
    end

    it 'shows publify with the current version as the generator' do
      assert_correct_atom_generator rendered
    end

    it 'renders a valid Atom feed with one item' do
      assert_atom10 rendered, 1
    end

    describe 'the trackback entry' do
      let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }

      it 'should have all the required attributes' do
        expect(rendered_entry.title).
          to eq "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        expect(rendered_entry.entry_id).to eq('urn:uuid:dsafsadffsdsf')
        expect(rendered_entry.summary).to eq('This is an excerpt')
        expect(rendered_entry.links.first).to eq("#{article.permalink_url}#trackback-#{trackback.id}")
      end
    end
  end
end
