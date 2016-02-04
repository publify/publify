require 'rails_helper'

describe Admin::SidebarController, type: :controller do
  before do
    FactoryGirl.create(:blog)
    # TODO: Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, login: 'henri', profile: FactoryGirl.create(:profile_admin, label: Profile::ADMIN))
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
