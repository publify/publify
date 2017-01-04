require 'rails_helper'

describe TrackbacksController, type: :controller do
  let!(:blog) { create(:blog) }

  describe '#index' do
    let!(:some) { create(:trackback, title: 'some') }
    let!(:items) { create(:trackback, title: 'items') }

    describe 'with :format => atom' do
      before { get :index, params: { format: :atom } }

      it { expect(response).to be_success }
      it { expect(assigns(:trackbacks)).to eq([some, items]) }
      it { expect(response).to render_template('index_atom_feed') }
    end

    describe 'with :format => rss' do
      before { get :index, params: { format: :rss } }

      it { expect(response).to be_success }
      it { expect(assigns(:trackbacks)).to eq([some, items]) }
      it { expect(response).to render_template('index_rss_feed') }
    end
  end

  describe '#create' do
    context 'with request forgery protection enabled' do
      let(:article) { create :article }

      before do
        ActionController::Base.allow_forgery_protection = true
      end

      after do
        ActionController::Base.allow_forgery_protection = false
      end

      it 'creates a Trackback when given valid params' do
        post :create, params: { article_id: article.id,
                                blog_name: 'Foo',
                                excerpt: 'Tracking you back!',
                                title: 'Bar',
                                url: 'http://www.foo.com/bar' }
        expect(Trackback.last.excerpt).to eq 'Tracking you back!'
      end
    end
  end
end
