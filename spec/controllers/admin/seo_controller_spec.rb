require 'rails_helper'

describe Admin::SeoController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let(:admin) { create(:user, :as_admin) }

  before(:each) { request.session = { user: admin.id } }

  describe 'index' do
    before(:each) { get :index }
    it { expect(response).to render_template('index') }
  end

  describe 'permalinks' do
    before(:each) { get :permalinks }
    it { expect(response).to render_template('permalinks') }
  end

  describe 'titles' do
    before(:each) { get :titles }
    it { expect(response).to render_template('titles') }
  end

  describe 'update' do
    before(:each) { post :update, from: 'permalinks', setting: { permalink_format: format } }

    context 'simple title format' do
      let(:format) { '/%title%' }
      it { expect(response).to redirect_to(action: 'permalinks') }
      it { expect(blog.reload.permalink_format).to eq(format) }
      it { expect(flash[:success]).to eq(I18n.t('admin.settings.update.success')) }
    end

    context 'without title format' do
      let(:format) { '/%month%' }
      it { expect(blog.reload.permalink_format).to_not eq(format) }
      it { expect(flash[:error]).to eq(I18n.t('admin.settings.update.error', messages: I18n.t('errors.permalink_need_a_title'))) }
    end
  end
end
