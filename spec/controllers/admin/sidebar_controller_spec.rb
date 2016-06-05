require 'rails_helper'

describe Admin::SidebarController, type: :controller do
  before do
    create(:blog)
    henri = create(:user, :as_admin)
    sign_in henri
  end

  describe 'rendering' do
    render_views

    it 'test_index' do
      get :index
      assert_template 'index'
      assert_select 'div[id="sidebar-config"]'
    end
  end

  describe '#update' do
    it 'updates content' do
      sidebar = FactoryGirl.create(:sidebar)

      post :update, id: sidebar.to_param, configure: { sidebar.id.to_s => { 'title' => 'Links', 'body' => 'another html' } }
      sidebar.reload

      expect(sidebar.config['body']).to eq('another html')
    end
  end
end
