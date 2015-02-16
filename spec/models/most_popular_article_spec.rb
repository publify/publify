require 'spec_helper'

describe MostPopularArticle do
  let!(:blog) { create(:blog) }


  describe 'validations' do
    context 'valid' do
      let(:articles) { create_list(:article, 3) }

      subject { described_class.new(articles: articles) }

      it 'has 3 articles' do
        expect(subject).to be_valid
      end
    end

    context 'invalid' do
      let(:not_enough_articles) { create_list(:article, 2) }
      let(:too_many_articles) { create_list(:article, 4) }

      subject { described_class.new }

      it 'has less than 3 articles' do
        subject.articles = not_enough_articles
        expect(subject).to be_invalid
      end

      it 'has more than 3 articles' do
        subject.articles = too_many_articles
        expect(subject).to be_invalid
      end
    end
  end
end
