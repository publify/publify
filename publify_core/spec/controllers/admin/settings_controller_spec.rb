require 'rails_helper'

describe Admin::SettingsController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }

  before(:each) do
    alice = create(:user, :as_admin, login: 'alice')
    sign_in alice
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
    it 'updates the settings' do
      post :update, setting: { blog_name: 'New name' }
      expect(blog.reload.blog_name).to eq 'New name'
    end

    it 'redirects to :index by default' do
      post :update, setting: { blog_name: 'New name' }
      expect(response).to redirect_to(admin_settings_path)
    end

    context 'when updating the language' do
      after do
        I18n.locale = :en
      end

      it 'sets the flash in the new language' do
        expect(I18n.locale).to eq :en
        post :update, setting: { lang: 'nl' }
        expect(I18n.locale).to eq :nl
        expect(flash[:success]).to eq I18n.t('admin.settings.update.success')
      end
    end
  end
end
