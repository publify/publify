# coding: utf-8
describe 'articles/index_json_feed.json.jbuilder', type: :view do
  let!(:blog) { build_stubbed :blog }

  describe 'rendering articles (with some funny characters)' do
    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])
      render
    end

    it 'creates an RSS feed with two items' do
      assert_json rendered, 2
    end

    it 'renders the article RSS partial twice' do
      expect(view).to render_template(partial: 'shared/_json_item_article', count: 2)
    end
  end

  describe 'rendering a single article' do
    before do
      @article = stub_full_article
      @article.body = 'public info'
      @article.extended = 'and more'
      assign(:articles, [@article])
    end

    describe 'on a blog that shows extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows the body and extended content in the feed' do
        expect(rendered_entry["description"]).to match(/public info.*and more/m)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = true
      end

      it 'shows only the body content in the feed if there is no excerpt' do
        render
        entry = rendered_entry
        expect(entry['description']).to match(/public info/)
        expect(entry['description']).not_to match(/public info.*and more/m)
      end

      it 'shows the excerpt instead of the body content in the feed, if there is an excerpt' do
        @article.excerpt = 'excerpt'
        render
        entry = rendered_entry
        expect(entry['description']).to match(/excerpt/)
        expect(entry['description']).not_to match(/public info/)
      end
    end

    describe 'on a blog that has an RSS description set' do
      before(:each) do
        Blog.default.rss_description = true
        Blog.default.rss_description_text = 'rss description'
        render
      end

      it 'shows the body content in the feed' do
        expect(rendered_entry['description']).to match(/public info/)
      end

      it 'shows the RSS description in the feed' do
        expect(rendered_entry['description']).to match(/rss description/)
      end
    end

  end

  describe 'rendering a password protected article' do
    before(:each) do
      @article = stub_full_article
      @article.body = "shh .. it's a secret!"
      @article.extended = 'even more secret!'
      allow(@article).to receive(:password) { 'password' }
      assign(:articles, [@article])
    end

    describe 'on a blog that shows extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = false
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry['description']).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      before(:each) do
        Blog.default.hide_extended_on_rss = true
        render
      end

      it 'shows only a link to the article' do
        expect(rendered_entry['description']).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>"
        )
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end
  end

  describe 'rendering an article with a UTF-8 permalink' do
    before(:each) do
      @article = stub_full_article
      @article.permalink = 'ルビー'
      assign(:articles, [@article])

      render
    end

    it 'creates a valid feed' do
      expect(JSON.parse(rendered)).to be_truthy
    end
  end

  def rendered_entry
    parsed = JSON.parse(rendered)
    parsed.first
  end

  describe '#title' do
    before(:each) do
      assign(:articles, [article])
      render
    end

    context 'with a note' do
      let(:article) { create(:note) }
      it { expect(rendered_entry['title']).to eq(article.body) }
    end

    context 'with an article' do
      let(:article) { create(:article) }
      it { expect(rendered_entry['title']).to eq(article.title) }
    end
  end

end
