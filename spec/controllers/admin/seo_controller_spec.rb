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

  describe 'update action' do
    def good_update(options = {})
      post :update, { 'from' => 'index',
                      'authenticity_token' => 'f9ed457901b96c65e99ecb73991b694bd6e7c56b',
                      'setting' => { 'permalink_format' => '/%title%.html',
                                     'unindex_categories' => '1',
                                     'google_analytics' => '',
                                     'meta_keywords' => 'my keywords',
                                     'meta_description' => '',
                                     'rss_description' => '1',
                                     'robots' => "User-agent: *\r\nDisallow: /admin/\r\nDisallow: /page/\r\nDisallow: /cgi-bin \r\nUser-agent: Googlebot-Image\r\nAllow: /*",
                                     'index_tags' => '1' } }.merge(options)
    end

    it 'should success' do
      good_update
      expect(response).to redirect_to(action: 'index')
    end

    it 'should not save blog with bad permalink format' do
      @blog = Blog.default
      good_update 'setting' => { 'permalink_format' => '/%month%' }
      expect(response).to redirect_to(action: 'index')
      expect(@blog).to eq(Blog.default)
    end
  end
end
