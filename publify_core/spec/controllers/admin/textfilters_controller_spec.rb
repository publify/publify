# frozen_string_literal: true

require 'rails_helper'

describe Admin::TextfiltersController, type: :controller do
  render_views

  describe 'macro help action' do
    before do
      create(:blog)
      henri = create(:user, :as_admin)
      sign_in henri
      get 'macro_help', params: { id: 'textile' }
    end

    it 'renders success' do
      expect(response).to be_successful
    end

    it 'contains help text' do
      expect(response.body).to match /Textile reference/
    end
  end
end
