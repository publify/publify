require 'rails_helper'

describe Admin::TagsController, :type => :controller do
  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, login: 'henri', profile: create(:profile_admin)) }

  before { request.session = { user: user.id } }

  describe 'index' do
    before(:each) { get :index }
    it { expect(response).to redirect_to(action: 'new') }
  end

  context "with a tag" do
    let(:tag) { create(:tag) }

    describe 'edit' do
      before(:each) { get :edit, id: tag.id }

      it { expect(response).to be_success }
      it { expect(response).to render_template('new') }
      it { expect(assigns(:tag)).to be_valid }
    end

    describe 'destroy' do
      context "with a get" do
        before(:each) { get :destroy, id: tag.id }

        it { expect(response).to be_success }
        it { expect(response).to render_template('destroy') }
        it { expect(assigns(:record)).to be_valid }

        context "with view" do
          render_views
          it { expect(response.body).to have_selector("form[action='/admin/tags/destroy/#{tag.id}'][method='post']") }
        end
      end

      context "with a post" do
        before(:each) { post :destroy, id: tag.id, tag: {display_name: 'Foo Bar'}}
        it { expect(response).to redirect_to(action: 'index') }
        it { expect(Tag.count).to eq(0) }
      end
    end

    describe 'update' do
      before(:each) { post :edit, id: tag.id, tag: {display_name: 'Foo Bar'} }
      it { expect(response).to be_success }
      it { expect(tag.reload.name).to eq('foo-bar') }
      it { expect(tag.reload.display_name).to eq('Foo Bar') }
      it { expect(Redirect.count).to eq(1) }
      it { expect(Redirect.first.to_path).to eq('/tag/foo-bar') }
    end
  end
end
