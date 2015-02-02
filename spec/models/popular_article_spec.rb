require 'spec_helper'


describe PopularArticle do
  let!(:blog) { create(:blog) }

  describe '#last_or_initialize' do
    context 'popular article list not created' do
      it 'creates a new popular article list' do
        expect(PopularArticle).to receive(:new)
        PopularArticle.last_or_initialize
      end
    end

    context 'popular article list already created' do
      it 'retrieves the existing popular article list' do
        PopularArticle.create

        expect(PopularArticle).to receive(:last)
        PopularArticle.last_or_initialize
      end
    end
  end

  describe '#articles' do
    before :each do
      3.times { create(:article) }
    end

    it 'has the most popular articles' do
      subject.articles = Article.all
      expect(subject.articles.first).to be_a(Article)
    end

    it 'must have 3 articles' do
      subject.update_attributes(article_ids: Article.pluck(:id))
      expect(subject.articles.size).to eq(3)
    end

    context 'invalid popular article' do
      it 'has less than 3 articles' do
        2.times { create(:article) }
        expect(subject).to be_invalid
      end
      it 'has more than 3 articles' do
        4.times { create(:article) }
        expect(subject).to be_invalid
      end
    end
  end
end
