# frozen_string_literal: true

require "rails_helper"

describe TextController, type: :controller do
  let!(:blog) { create(:blog) }

  describe "robots" do
    before { get :robots, params: { format: "txt" } }

    it { expect(response).to be_successful }
    it { expect(response.body).to eq(blog.robots) }
  end
end
