describe 'comments/index_atom_feed.atom.builder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering comments with one comment' do
    let(:article) { stub_full_article }
    let(:comment) { build(:comment, article: article, body: 'Comment body', guid: '12313123123123123') }

    before(:each) do
      assign(:items, [comment])
      render
    end

    it 'shows publify with the current version as the generator' do
      xml = Nokogiri::XML.parse(rendered)
      generator = xml.css('generator').first
      expect(generator.content).to eq('Publify')
      expect(generator['version']).to eq(PUBLIFY_VERSION)
    end

    it 'should render an Atom feed with one item' do
      assert_atom10 rendered, 1
    end

    describe 'the comment entry' do
      it 'should have all the required attributes' do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css('entry').first

        expect(entry_xml.css('title').first.content).to eq(
          "Comment on #{article.title} by #{comment.author}"
        )
        expect(entry_xml.css('id').first.content).to eq('urn:uuid:12313123123123123')
        expect(entry_xml.css('content').first.content).to eq('<p>Comment body</p>')
        link_xml = entry_xml.css('link').first
        expect(link_xml['href']).to eq("#{article.permalink_url}#comment-#{comment.id}")
      end
    end
  end
end
