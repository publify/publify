require 'rails_helper'

describe Admin::SettingsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }

  before(:each) do
    alice = create(:user, :as_admin, login: 'alice')
    request.session = { user: alice.id }
  end

  describe '#index' do
    before(:each) { get :index }
    it { expect(response).to render_template('index') }
  end

  describe '#write' do
    before(:each) { get :write }
    it { expect(response).to render_template('write') }
  end

  describe '#display' do
    before(:each) { get :display }
    it { expect(response).to render_template('display') }
  end

  describe '#feedback' do
    before(:each) { get :feedback }
    it { expect(response).to render_template('feedback') }
  end

  describe '#update' do
    before do
      post :update, setting: { blog_name: 'New name'}
    end

    it 'updates the settings' do
      expect(blog.reload.blog_name).to eq 'New name'
    end

    it 'redirects to :index by default' do
      # FIXME: Make this a named route
      expect(response).to redirect_to('/admin/settings')
    end
  end
end
