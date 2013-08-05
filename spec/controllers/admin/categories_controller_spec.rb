require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before(:each) do
    create(:blog)
    henri = create(:user, login: 'henri', profile: create(:profile_admin, label: Profile::ADMIN))
    request.session = { user: henri.id }
  end

  describe :index do
    before(:each) { get :index }
    it { expect(response).to redirect_to(action: 'new') }
  end

  describe :edit do
    context "when no category exist" do
      before(:each) { post :edit, category: { name: "test category" }}
      it { expect(response).to redirect_to(action: 'index') }
    end

    context "with an existing category" do
      let!(:category) { create(:category) }

      context "when use post method" do
        before(:each) { post :edit, id: category.id, category: { name: "new category name" }}
        it { expect(response).to redirect_to(action: 'index') }
      end

      context "when use get method" do
        before(:each) { get :edit, id: create(:category).id }

        context "with an existing category" do
          let!(:category) { create(:category) }

          it { expect(response).to render_template('new') }
          it { expect(response.body).to have_selector('table', id: 'category_container')}
          it { expect(assigns(:category)).to_not be_nil }
          it { expect(assigns(:category)).to be_valid }
          it { expect(assigns(:categories)).to_not be_nil }
        end
      end
    end
  end

  describe :new do
    before(:each) { get :new }
    it { expect(response).to render_template('new') }
    it { expect(response.body).to have_selector('table', id: 'category_container')}
  end

  describe :destroy do
    let!(:category) { create(:category) }

    context "with get method" do
      before(:each) { get :destroy, id: category.id }
      it { expect(response).to be_success }
      it { expect(response).to render_template('destroy') }
    end

    context "with post method" do
      before(:each) { post :destroy, id: category.id }
      it { expect(response).to redirect_to(action: 'index') }
      it { expect(Category.count).to eq(0) }
    end
  end
end
