# frozen_string_literal: true

require 'rails_helper'

describe 'articles/index_rss_feed.rss.builder', type: :view do
  let(:rendered_entry) { Feedjira::Feed.parse(rendered).entries.first }
  let(:xml_entry) { Nokogiri::XML.parse(rendered).css('item').first }

  describe 'rendering articles (with some funny characters)' do
    let!(:blog) { create :blog }

    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])
      render
    end

    it 'creates a valid RSS feed with two items' do
      assert_rss20 rendered, 2
    end

    it 'renders the article RSS partial twice' do
      expect(view).to render_template(partial: 'shared/_rss_item_article', count: 2)
    end
  end

  describe 'rendering a single article' do
    let(:blog) { create :blog }

    before do
      @article = stub_full_article(blog: blog)
      @article.body = 'public info'
      @article.extended = 'and more'
      assign(:articles, [@article])
    end

    it 'has the correct guid' do
      render
      expect(rendered_entry.entry_id).to eq "urn:uuid:#{@article.guid}"
    end

    it "has a link to the article's comment section" do
      render
      expect(xml_entry.css('comments').first.content).to eq(@article.permalink_url + '#comments')
    end

    it 'has a creator entry' do
      render
      expect(xml_entry.xpath('dc:creator').first.content).to eq @article.author_name
      expect(rendered_entry.author).to eq @article.author_name
    end

    describe 'with an author with email set' do
      before do
        @article.user.email = 'foo@bar.com'
        render
      end

      it 'does not have an author entry' do
        expect(xml_entry.xpath('author')).to be_empty
      end
    end

    describe 'on a blog that shows extended content in feeds' do
      let(:blog) { create :blog, hide_extended_on_rss: false }

      before do
        render
      end

      it 'shows the body and extended content in the feed' do
        expect(rendered_entry.summary).to match(/public info.*and more/m)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      let(:blog) { create :blog, hide_extended_on_rss: true }

      it 'shows only the body content in the feed if there is no excerpt' do
        render
        expect(rendered_entry.summary).to match(/public info/)
        expect(rendered_entry.summary).not_to match(/public info.*and more/m)
      end

      it 'shows the excerpt instead of the body content in the feed, if there is an excerpt' do
        @article.excerpt = 'excerpt'
        render
        expect(rendered_entry.summary).to match(/excerpt/)
        expect(rendered_entry.summary).not_to match(/public info/)
      end
    end

    describe 'on a blog that has an RSS description set' do
      let(:blog) do
        create :blog, rss_description: true,
                      rss_description_text: 'rss description'
      end

      before do
        render
      end

      it 'shows the body content in the feed' do
        expect(rendered_entry.summary).to match(/public info/)
      end

      it 'shows the RSS description in the feed' do
        expect(rendered_entry.summary).to match(/rss description/)
      end
    end
  end

  describe 'rendering a password protected article' do
    before do
      @article = stub_full_article(blog: blog)
      @article.body = "shh .. it's a secret!"
      @article.extended = 'even more secret!'
      allow(@article).to receive(:password).and_return('password')
      assign(:articles, [@article])
      render
    end

    describe 'on a blog that shows extended content in feeds' do
      let(:blog) { create :blog, hide_extended_on_rss: false }

      it 'shows only a link to the article' do
        expect(rendered_entry.summary).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>")
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end

    describe 'on a blog that hides extended content in feeds' do
      let(:blog) { create :blog, hide_extended_on_rss: true }

      it 'shows only a link to the article' do
        expect(rendered_entry.summary).to eq(
          "<p>This article is password protected. Please <a href='#{@article.permalink_url}'>fill in your password</a> to read it</p>")
      end

      it 'does not show any secret bits anywhere' do
        expect(rendered).not_to match(/secret/)
      end
    end
  end

  describe 'rendering an article with a UTF-8 permalink' do
    let(:blog) { create :blog }

    before do
      @article = stub_full_article(blog: blog)
      @article.permalink = 'ルビー'
      assign(:articles, [@article])

      render
    end

    it 'creates a valid RSS feed with one item' do
      assert_rss20 rendered, 1
    end
  end

  describe '#title' do
    before do
      assign(:articles, [article])
      render
    end

    context 'with a note' do
      let(:article) { create(:note) }

      it 'is equal to the note body' do
        expect(rendered_entry.title).to eq(article.body)
      end
    end

    context 'with an article' do
      let(:article) { create(:article) }

      it 'is equal to the article title' do
        expect(rendered_entry.title).to eq(article.title)
      end
    end
  end
end
