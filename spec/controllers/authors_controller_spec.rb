require 'spec_helper'

describe AuthorsController do
  describe '#show' do
    let!(:blog) { FactoryGirl.create(:blog) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:article) { FactoryGirl.create(:article, :user => user) }
    let!(:unpublished_article) { FactoryGirl.create(:unpublished_article, :user => user) }

    describe "as html" do
      before do
        get 'show', :id => user.login
      end

      it 'renders the :show template' do
        response.should render_template(:show)
      end

      it 'assigns author' do
        assigns(:author).should == user
      end

      it 'assigns articles as published articles' do
        assigns(:articles).should == [article]
      end

      describe "when rendered" do
        render_views

        it 'has a link to the rss feed' do
          response.should have_selector("head>link[href=\"http://test.host/author/#{user.login}.rss\"]")
        end

        it 'has a link to the atom feed' do
          response.should have_selector("head>link[href=\"http://test.host/author/#{user.login}.atom\"]")
        end
      end
    end

    describe "as an atom feed" do
      before do
        get 'show', :id => user.login, :format => 'atom'
      end

      it 'assigns articles as published articles' do
        assigns(:articles).should == [article]
      end

      it "renders the atom template" do
        response.should be_success
        response.should render_template("show_atom_feed")
      end

      it "does not render layout" do
        @layouts.keys.compact.should be_empty
      end
    end

    describe "as an rss feed" do
      before do
        get 'show', :id => user.login, :format => 'rss'
      end

      it 'assigns articles as published articles' do
        assigns(:articles).should == [article]
      end

      it "renders the rss template" do
        response.should be_success
        response.should render_template("show_rss_feed")
      end

      it "does not render layout" do
        @layouts.keys.compact.should be_empty
      end
    end
  end
end

describe AuthorsController, "SEO options" do
  render_views

  it 'should never have meta keywords with deactivated option' do
    FactoryGirl.create(:blog, :use_meta_keyword => false)
    FactoryGirl.create(:user, :login => 'henri')
    get 'show', :id => 'henri'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should never have meta keywords with deactivated option' do
    FactoryGirl.create(:blog, :use_meta_keyword => true)
    FactoryGirl.create(:user, :login => 'alice')
    get 'show', :id => 'alice'
    response.should_not have_selector('head>meta[name="keywords"]')
  end

end
