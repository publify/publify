require 'rails_helper'

describe CommentsController, type: :controller do
  let!(:blog) { create(:blog) }

  describe 'create' do
    describe 'Basic comment creation' do
      let(:article) { create(:article) }
      let(:comment) { { body: 'content', author: 'bob', email: 'bob@home', url: 'http://bobs.home/' } }

      before { post :create, comment: comment, article_id: article.id }

      it { expect(assigns[:comment]).to eq(Comment.find_by_author_and_body_and_article_id('bob', 'content', article.id)) }
      it { expect(assigns[:article]).to eq(article) }
      it { expect(article.comments.size).to eq(1) }
      it { expect(article.comments.last.author).to eq('bob') }
      it { expect(cookies['author']).to eq('bob') }
      it { expect(cookies['gravatar_id']).to eq(Digest::MD5.hexdigest('bob@home')) }
      it { expect(cookies['url']).to eq('http://bobs.home/') }
    end

    it 'should redirect to the article' do
      article = create(:article, created_at: '2005-01-01 02:00:00')
      post :create, comment: { body: 'content', author: 'bob' }, article_id: article.id
      expect(response).to redirect_to("/#{article.created_at.year}/#{sprintf('%.2d', article.created_at.month)}/#{sprintf('%.2d', article.created_at.day)}/#{article.permalink}")
    end
  end

  describe 'AJAX creation' do
    it 'should render the comment partial' do
      xhr :post, :create, comment: { body: 'content', author: 'bob' }, article_id: create(:article).id
      expect(response).to render_template('articles/_comment')
    end
  end

  describe 'index' do
    context 'scoped index' do
      let(:article) { create(:article) }
      before(:each) { get 'index', article_id: article.id }
      it { expect(response).to redirect_to("#{URI.parse(article.permalink_url).path}#comments") }
    end

    context 'without format' do
      before(:each) { get :index }
      it { expect(response).to be_success }
      it { expect(assigns(:comments)).to be_nil }
    end

    context 'with atom format' do
      context 'without article' do
        let!(:some) { create(:comment) }
        let!(:items) { create(:comment) }

        before(:each) { get 'index', format: 'atom' }

        it { expect(response).to be_success }
        it { expect(assigns(:comments)).to eq([some, items]) }
        it { expect(response).to render_template('index_atom_feed') }
      end

      context 'with an article' do
        let!(:article) { create(:article) }
        before(:each) { get :index, format: 'atom', article_id: article.id }
        it { expect(response).to be_success }
        it { expect(response).to render_template('index_atom_feed') }
      end
    end

    context 'with rss format' do
      context 'without article' do
        let!(:some) { create(:comment, title: 'some') }
        let!(:items) { create(:comment, title: 'items') }

        before { get 'index', format: 'rss' }
        it { expect(response).to be_success }
        it { expect(assigns(:comments)).to eq([some, items]) }
        it { expect(response).to render_template('index_rss_feed') }
      end

      context 'with article' do
        let!(:article) { create(:article) }
        before(:each) { get :index, format: 'rss', article_id: article.id }

        it { expect(response).to be_success }
        it { expect(response).to render_template('index_rss_feed') }
      end
    end
  end
end
