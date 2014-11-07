require 'rails_helper'

RSpec.describe StyleguideController, type: :controller do

  before { allow(Blog).to receive(:default) { double(lang: 'en') } }

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
