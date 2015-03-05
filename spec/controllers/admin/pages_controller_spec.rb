# coding: utf-8
require 'rails_helper'

describe Admin::PagesController, type: :controller do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user, :as_admin) }

  before(:each) { request.session = { user: user.id } }

  describe 'GET #index' do
    context 'without params' do
      before(:each) { get :index }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end

    context 'with page 1' do
      before(:each) { get :index, page: 1 }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end
  end

  describe 'GET #new' do
    context 'should get a new form' do
      before(:each) { get :new }

      it { expect(response).to be_success }
      it { expect(response).to render_template('new') }
      it { expect(assigns(:page)).to_not be_nil }
      it { expect(assigns(:page).user).to eq(user) }
      it { expect(assigns(:page).text_filter.name).to eq('textile') }
      it { expect(assigns(:page).published).to be_truthy }
    end
  end

  describe 'POST #create' do
    context 'should create a new page' do
      def base_page(options = {})
        { title: 'posted via tests!',
          body: 'A good body',
          name: 'posted-via-tests',
          published: true }.merge(options)
      end

      context 'simple' do
        before(:each) do
          post :create, page: { name: 'new_page', title: 'New Page Title', body: 'Emphasis _mine_, arguments *strong*' }
        end

        it { expect(Page.first.name).to eq('new_page') }
        it { expect(response).to redirect_to(action: :index) }
      end

      it 'should create a published page with a redirect' do
        post(:create, 'page' => base_page)
        expect(assigns(:page).redirects.count).to eq(1)
      end

      it 'should create an unpublished page without a redirect' do
        post(:create, 'page' => base_page(state: :unpublished, published: false))
        expect(assigns(:page).redirects.count).to eq(0)
      end

      it 'should create a page published in the future without a redirect' do
        # TODO: published_at parameter is currently ignored
        skip
        post(:create, 'page' => base_page(published_at: (Time.now + 1.hour).to_s))
        expect(assigns(:page).redirects.count).to eq(0)
      end
    end
  end

  describe '#edit' do
    let!(:page) { create(:page) }

    context 'should get the edit page' do
      before(:each) { get :edit, id: page.id }
      it { expect(response).to be_success }
      it { expect(response).to render_template('edit') }
      it { expect(assigns(:page)).to eq(page) }
    end
  end

  describe '#update' do
    let!(:page) { create(:page) }

    context 'should update a post' do
      before(:each) do
        post :update, id: page.id, page: { name: 'markdown-page', title: 'Markdown Page', body: 'Adding a [link](http://www.publify.co/) here' }
      end

      it { expect(response).to redirect_to(action: :index) }
    end
  end

  describe 'destroy' do
    let!(:page) { create(:page) }

    before(:each) { post :destroy, id: page.id }

    it { expect(response).to redirect_to(action: :index) }
    it { expect(Page.count).to eq(0) }
  end
end
