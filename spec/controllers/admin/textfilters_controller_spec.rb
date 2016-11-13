require 'rails_helper'

describe Admin::TextfiltersController, type: :controller do
  render_views

  describe 'macro help action' do
    it 'should render success' do
      create(:blog)
      henri = create(:user, :as_admin)
      sign_in henri
      get 'macro_help', id: 'textile'
      expect(response).to be_success
    end
  end
end
