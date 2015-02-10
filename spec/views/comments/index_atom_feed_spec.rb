require 'rails_helper'

describe 'comments/index_atom_feed.atom.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering comments with one comment' do
    let(:article) { stub_full_article }
    let(:comment) do
      build_stubbed(:comment,
                    article: article,
                    body: 'Comment body',
                    guid: '12313123123123123')
    end

    before(:each) do
      assign(:items, [comment])
      render
    end

    it 'shows publify with the current version as the generator' do
      assert_correct_atom_generator rendered
    end

    it 'renders a valid Atom feed with one item' do
      assert_atom10 rendered, 1
    end

    describe 'the comment entry' do
      let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }

      it 'should have all the required attributes' do
        expect(rendered_entry.title).to eq "Comment on #{article.title} by #{comment.author}"
        expect(rendered_entry.entry_id).to eq 'urn:uuid:12313123123123123'
        expect(rendered_entry.content).to eq '<p>Comment body</p>'
        expect(rendered_entry.links.first).to eq "#{article.permalink_url}#comment-#{comment.id}"
      end
    end
  end
end
