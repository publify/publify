require 'rails_helper'

describe TextController, type: :controller do
  let!(:blog) { create(:blog) }

  describe 'humans' do
    before(:each) { get :humans, format: 'txt' }

    it { expect(response).to be_success }
    it { expect(response.body).to eq(blog.humans) }
  end

  describe 'robots' do
    before(:each) { get :robots, format: 'txt' }

    it { expect(response).to be_success }
    it { expect(response.body).to eq(blog.robots) }
  end
end
