require 'rails_helper'

describe Article::Builder, type: :model do
  let!(:blog) { FactoryGirl.build_stubbed(:blog) }
  let(:user) { FactoryGirl.create(:user) }
  let(:factory) { Article::Factory.new(blog, user) }

  describe '#default' do
    let(:new_article) { factory.default }

    it { expect(new_article.allow_comments).to eq(blog.default_allow_comments) }
    it { expect(new_article.allow_pings).to eq(blog.default_allow_pings) }
    it { expect(new_article.text_filter).to eq(user.default_text_filter) }
    it { expect(new_article.published).to be_truthy }
  end

  describe '#get_or_build' do
    context 'with an existing article' do
      let(:article) { FactoryGirl.create(:article) }
      it { expect(factory.get_or_build_from(article.id)).to eq(article) }
    end

    context 'with nil given' do
      let(:new_article) { factory.get_or_build_from(nil) }

      it { expect(new_article).to be_kind_of(Article) }
      it { expect(new_article.id).to be_nil }
      it { expect(new_article.published).to be_truthy }
      it { expect(new_article.allow_pings).to eq(blog.default_allow_pings) }
      it { expect(new_article.allow_comments).to eq(blog.default_allow_comments) }
      it { expect(new_article.text_filter).to eq(user.default_text_filter) }
    end
  end

  describe '#requested_article' do
    it 'call find_by_permalink' do
      params = { something: 'truc' }
      expect(Article).to receive(:find_by_permalink).with(params)
      expect(factory.requested_article(params)).to be_nil
    end

    it 'set title params with article_id params' do
      params = { article_id: 12 }
      expected_params = params.merge(title: 12)
      expect(Article).to receive(:find_by_permalink).with(expected_params)
      expect(factory.requested_article(params)).to be_nil
    end

    it 'dont set title params with article_id when title already set' do
      params = { article_id: 12, title: 'Beautiful' }
      expected_params = params
      expect(Article).to receive(:find_by_permalink).with(expected_params)
      expect(factory.requested_article(params)).to be_nil
    end
  end

  describe '#match_permalink_format' do
    let!(:article) { create(:article, permalink: 'a-title') }

    context 'with one more element on url than on format' do
      let(:url) { '/one/two/three' }
      let(:format) { '/year/title' }

      it { expect(factory.match_permalink_format(url, format)).to be_nil }
    end

    context 'with hard part in format, return nil if url doesnt match' do
      let(:url) { '/one/two' }
      let(:format) { '/three/two' }

      it { expect(factory.match_permalink_format(url, format)).to be_nil }
    end

    context 'with format and matching article' do
      let(:url) { 'a-title' }
      let(:format) { '/%title%' }

      it { expect(factory.match_permalink_format(url, format)).to eq(article) }
    end
  end
end
