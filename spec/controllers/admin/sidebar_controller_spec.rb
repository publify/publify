require 'rails_helper'

describe Admin::SidebarController, type: :controller do
  let!(:blog) { create(:blog) }

  before do
    henri = create(:user, :as_admin)
    sign_in henri
  end

  describe '#index' do
    context 'when rendering' do
      render_views

      it 'renders the sidebar configuration' do
        get :index
        assert_template 'index'
        assert_select 'div#sidebar-config'
      end
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
    render_views

    it 'creates new sidebars in the current blog' do
      post :sortable, sidebar: ['9001']
      expect(blog.sidebars.count).to eq 1
    end

    it 'renders template for js response' do
      post :sortable, sidebar: ['9001'], format: :js
      expect(response).to be_success
      expect(response).to render_template(:sortable)
    end
  end
end
