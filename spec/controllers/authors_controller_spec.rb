require 'rails_helper'

describe AuthorsController, type: :controller do
  let!(:blog) { create(:blog, limit_article_display: 1) }
  let(:now) { DateTime.new(2012, 12, 23, 3, 45) }

  describe '#show' do
    describe 'With an empty profile' do
      let(:no_profile_user) { create(:user, :without_twitter) }
      let!(:article) { create(:article, user: no_profile_user, published_at: now - 1.hour) }

      describe 'html' do
        before(:each) { get 'show', id: no_profile_user.login }

        it { expect(response).to render_template(:show) }
        it { expect(assigns(:author)).to eq(no_profile_user) }
        it { expect(assigns(:articles)).to eq([article]) }
      end

      describe 'atom feed' do
        before(:each) { get 'show', id: no_profile_user.login, format: 'atom' }
        it { expect(response).to render_template(:show_atom_feed, false) }
      end

      describe 'rss feed' do
        before(:each) { get 'show', id: no_profile_user.login, format: 'rss' }
        it { expect(response).to render_template(:show_rss_feed, false) }
      end

      describe 'with pagination' do
        let!(:article_page_2) { create(:article, user: no_profile_user, published_at: now - 1.day) }
        before(:each) { get 'show', id: no_profile_user.login, page: 2 }
        it { expect(assigns(:articles)).to eq([article_page_2]) }
      end
    end

    describe 'With full profile' do
      let!(:full_profile_user) { create(:user, :with_a_full_profile) }
      let!(:article) { create(:article, user: full_profile_user) }

      describe 'html' do
        before(:each) { get 'show', id: full_profile_user.login }

        it { expect(response).to render_template(:show) }
        it { expect(assigns(:author)).to eq(full_profile_user) }
        it { expect(assigns(:articles)).to eq([article]) }
      end
    end
  end
end
