# coding: utf-8
require 'spec_helper'

describe Admin::PagesController do
  render_views

  let!(:blog) { create(:blog) }
  let!(:user) { create(:user_admin) }

  before(:each) { request.session = { user: user.id } }

  describe :index do
    context "without params" do
      before(:each) { get :index }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end

    context "with page 1" do
      before(:each) { get :index, page: 1 }
      it { expect(response).to be_success }
      it { expect(response).to render_template('index') }
      it { expect(assigns(:pages)).to_not be_nil }
    end
  end

  describe :new do
    context "using get" do
      before(:each) { get :new }

      it { expect(response).to be_success }
      it { expect(response).to render_template("new") }
      it { expect(assigns(:page)).to_not be_nil }
      it { expect(assigns(:page).user).to eq(user) }
      it { expect(assigns(:page).text_filter.name).to eq('textile') }
    end

    context "using post" do

      def base_page(options={})
        { :title => "posted via tests!",
          :body => "A good body",
          :name => "posted-via-tests",
          :published => true }.merge(options)
      end

      context "simple" do
        before(:each) do
          post :new, page: { name: "new_page", title: "New Page Title", body: "Emphasis _mine_, arguments *strong*" } 
        end

        it { expect(Page.first.name).to eq("new_page") } 
        it { expect(response).to redirect_to(action: :index) }
        it { expect(session[:gflash][:success]).to eq([I18n.t('gflash.admin.pages.new.success')]) }
      end

      it 'should create a published page with a redirect' do
        post(:new, 'page' => base_page)
        assigns(:page).redirects.count.should == 1
      end

      it 'should create an unpublished page without a redirect' do
        post(:new, 'page' => base_page({:published => false}))
        assigns(:page).redirects.count.should == 0
      end

      it 'should create a page published in the future without a redirect' do
        pending ":published_at parameter is currently ignored"
        post(:new, 'page' => base_page({:published_at => (Time.now + 1.hour).to_s}))
        assigns(:page).redirects.count.should == 0
      end

    end
  end

  describe :edit do
    let!(:page) { create(:page) }

    context "using get" do
      before(:each) { get :edit, id: page.id }
      it { expect(response).to be_success }
      it { expect(response).to render_template("edit") }
      it { expect(assigns(:page)).to eq(page)}
    end

    context "using post" do
      before(:each) do
        post :edit, id: page.id, page: { name: "markdown-page", title: "Markdown Page", body: "Adding a [link](http://www.publify.co/) here" }
      end

      it {expect(response).to redirect_to(action: :index)}
    end
  end

  describe :destroy do
    let!(:page) { create(:page) }

    before(:each) { post :destroy, id: page.id }

    it { expect(response).to redirect_to(action: :index) }
    it { expect(Page.count).to eq(0) }
  end
end

