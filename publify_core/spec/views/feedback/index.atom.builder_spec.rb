require 'rails_helper'

RSpec.describe 'feedback/index.atom.builder', type: :view do
  describe 'rendering feedback' do
    let(:article) { build_stubbed(:article) }
    let(:comment) do
      build_stubbed(:comment,
                    article: article,
                    body: 'Comment body',
                    guid: '12313123123123123')
    end
    let(:trackback) { build_stubbed(:trackback, article: article) }

    before(:each) do
      assign(:feedback, [comment, trackback])
      render
    end

    it 'shows publify with the current version as the generator' do
      assert_correct_atom_generator rendered
    end

    it 'renders a valid Atom feed with two items' do
      assert_atom10 rendered, 2
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

    describe 'the trackback entry' do
      let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.last }

      it 'should have all the required attributes' do
        expect(rendered_entry.title).
          to eq "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        expect(rendered_entry.entry_id).to eq('urn:uuid:dsafsadffsdsf')
        expect(rendered_entry.summary).to eq('This is an excerpt')
        expect(rendered_entry.links.first).
          to eq("#{article.permalink_url}#trackback-#{trackback.id}")
      end
    end
  end
end
