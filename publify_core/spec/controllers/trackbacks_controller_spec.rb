require 'rails_helper'

describe TrackbacksController, type: :controller do
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
