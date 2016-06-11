require 'rails_helper'

describe Admin::SidebarController, type: :controller do
  let!(:blog) { create(:blog) }

  before do
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

      post :update, id: sidebar.to_param,
                    configure: { sidebar.id.to_s => { 'title' => 'Links', 'body' => 'another html' } }
      sidebar.reload

      expect(sidebar.config['body']).to eq('another html')
    end
  end

  describe '#sortable' do
    it 'creates new sidebars in the current blog' do
      post :sortable, sidebar: ['9001']
      expect(blog.sidebars.count).to eq 1
    end
  end
end
