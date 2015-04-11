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
end
