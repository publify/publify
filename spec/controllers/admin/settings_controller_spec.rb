require 'rails_helper'

describe Admin::SettingsController, type: :controller do
  render_views

  before(:each) do
    create(:blog)
    alice = create(:user, :as_admin, login: 'alice')
    request.session = { user: alice.id }
  end

  describe '#index' do
    before(:each) { get :index }
    it { expect(response).to render_template('index') }
  end

  describe 'write action' do
    before(:each) { get :write }
    it { expect(response).to render_template('write') }
  end

  describe 'display action' do
    before(:each) { get :display }
    it { expect(response).to render_template('display') }
  end

  describe 'feedback action' do
    before(:each) { get :feedback }
    it { expect(response).to render_template('feedback') }
  end

  describe 'update database action' do
    before(:each) { get :update_database }
    it { expect(response).to render_template('update_database') }
  end

  describe 'update action' do
    def good_update(options = {})
      post :update, { 'from' => 'seo',
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
      expect(response).to redirect_to(action: 'seo')
    end

    it 'should not save blog with bad permalink format' do
      @blog = Blog.default
      good_update 'setting' => { 'permalink_format' => '/%month%' }
      expect(response).to redirect_to(action: 'seo')
      expect(@blog).to eq(Blog.default)
    end
  end
end
