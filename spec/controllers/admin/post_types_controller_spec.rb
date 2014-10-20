require 'rails_helper'

describe Admin::PostTypesController, :type => :controller do
  render_views

  before do
    create(:blog)
    user = create(:user, :as_admin)
    request.session = { user: user.id }
  end

  describe 'index' do
    before(:each) { get :index }
    it { expect(response).to redirect_to(action: 'new') }
  end

  describe "#edit" do
    context "when create a new one" do
      before(:each) {post :edit, post_type: {name: "new post type"}}
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(PostType.count).to eq(1) }
      it { expect(PostType.first.name).to eq("new post type") }
    end

    context "when update an existing one" do
      let(:post_type) { create(:post_type, name: 'a name') }
      before(:each) {post :edit, id: post_type.id, post_type: {name: 'an other name'}}
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(PostType.count).to eq(1) }
      it { expect(PostType.first.name).to eq('an other name') }
    end

    context "when edit with a get method" do
      before(:each) {get :edit, post_type: {name: "new post type"}}
      it { expect(response).to render_template('new') }
    end

  end

  describe 'new' do
    before(:each) { get :new }
    it { expect(response).to render_template('new')}
  end

  describe 'destroy' do
    let!(:post_type) { create(:post_type) }

    context "with a get method" do
      before(:each) { get :destroy, id: post_type.id }
      it { expect(response).to be_success }
      it { expect(response).to render_template('destroy') }
    end

    context "with a post method" do
      before(:each) { post :destroy, id: post_type.id }
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(PostType.count).to eq(0) }
    end
  end
end
