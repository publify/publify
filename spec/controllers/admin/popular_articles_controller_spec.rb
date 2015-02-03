require 'spec_helper'

describe Admin::PopularArticlesController do
  let!(:blog) { create(:blog) }

  let!(:user) { create(:user, :as_publisher) }
  before(:each) { request.session = { user: user.id } }

  describe "#new" do
    context 'popular articles never created' do
      it 'a new popular articles list will be generated' do
        expect(PopularArticle).to receive(:new).at_least(:once)
        get :new
      end
    end

    context 'popular articles already created' do
      before(:each) do
        create_list(:article, 3)
      end

      let(:popular_article) { PopularArticle.new(article_ids: Article.pluck(:id)) }

      it 'the existing popular article list will be found' do
        allow(PopularArticle).to receive(:last).and_return(popular_article)

        expect(PopularArticle).to receive(:last).at_least(:once)
        expect(PopularArticle).not_to receive(:new)
        get :new
      end
    end
  end

  describe "#create" do
    context 'valid popular article list' do
      before(:each) do
        create_list(:article, 3)
      end

      it 'must have 3 articles' do
        post :create, { popular_article: { article_ids: Article.pluck(:id) } }

        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    context 'popular articles never created' do
      before :each do
        create_list(:article, 3)
      end

      it 'a new popular articles list will be generated' do
        expect(PopularArticle).to receive(:new).at_least(:once).and_return PopularArticle.new

        post :create, { popular_article: { article_ids: Article.pluck(:id) } }
      end
    end

    context 'popular articles already created' do
      before(:each) do
        create_list(:article, 3)
      end

      let(:popular_article) { PopularArticle.new(article_ids: Article.all.collect(&:id)) }

      it 'the existing popular article list with be found' do
        allow(PopularArticle).to receive(:last).and_return(popular_article)

        expect(PopularArticle).to receive(:last)
        expect(PopularArticle).not_to receive(:new)
        post :create, { popular_article: { article_ids: Article.pluck(:id) } }
      end
    end
  end
end
