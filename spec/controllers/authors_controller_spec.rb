require 'spec_helper'

describe AuthorsController do
  describe '#show' do
    let!(:blog) { Factory(:blog) }
    let!(:user) { Factory(:user) }
    let!(:article) { Factory(:article, :user => user) }

    describe "as html" do
      before do
        get 'show', :id => user.login
      end

      it 'renders the :show template' do
        response.should render_template(:show)
      end

      it 'assigns author and articles' do
        assigns(:author).should == user
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

      it "renders the atom template" do
        response.should be_success
        response.should render_template("shared/_atom_feed")
      end
    end

    describe "as an rss feed" do
      before do
        get 'show', :id => user.login, :format => 'rss'
      end

      it "renders the rss template" do
        response.should be_success
        response.should render_template("shared/_rss20_feed")
      end
    end
  end
end

describe AuthorsController, "SEO options" do
  render_views

  before :each do
    @blog = Factory(:blog, :use_meta_keyword => false)
  end

  it 'should never have meta keywords with deactivated option' do
    get 'show', :id => 'tobi'
    
    response.should_not have_selector('head>meta[name="keywords"]')
  end

  it 'should never have meta keywords with deactivated option' do
    @blog.use_meta_keyword = true
    @blog.save
    get 'show', :id => 'tobi'
    
    response.should_not have_selector('head>meta[name="keywords"]')
  end

end
