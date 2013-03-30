require 'spec_helper'

describe CategoriesController do
  describe "/index" do
    before do
      create(:blog)
      @categories = 3.times.map {
        create(:category).tap { |category|
          2.times { category.articles << FactoryGirl.create(:article) }
        }
      }
    end

    describe "normally" do
      before do
        get 'index'
      end

      specify { response.should be_success }
      specify { response.should render_template('categories/index') }
      specify { assigns(:categories).should =~ @categories }
    end
  end

  describe '#show' do
    before do
      blog = FactoryGirl.create(:blog, base_url: "http://myblog.net", theme: "typographic", use_canonical_url: true, blog_name: "My Shiny Weblog!")
      Trigger.stub(:fire) { }

      category = FactoryGirl.create(:category, permalink: 'personal', name: 'Personal')
      2.times {|i| FactoryGirl.create(:article, published_at: Time.now - 3.minutes, categories: [category]) }
      Article.count.should eq 2
      FactoryGirl.create(:article, published_at: nil)
    end

    it 'should be successful' do
      get 'show', id: 'personal'
      response.should be_success
    end

    it 'should fall back to rendering articles/index' do
      controller.stub(:template_exists?).and_return(false)
      get 'show', id: 'personal'
      response.should render_template('articles/index')
    end

    it 'should render personal when template exists' do
      pending "Stubbing #template_exists is not enough to fool Rails"
      controller.stub(:template_exists?).and_return(true)
      get 'show', :id => 'personal'
      response.should render_template('personal')
    end

    it 'should show only published articles' do
      get 'show', :id => 'personal'
      assigns(:articles).size.should == 2
    end

    it 'should set the page title to "Category Personal"' do
      get 'show', :id => 'personal'
      assigns[:page_title].should == 'Category: Personal | My Shiny Weblog! '
    end

    describe "@keywords" do
      let(:category) { build_stubbed :category, :permalink => 'personal', keywords: keywords }

      before do
        Category.stub(:find_by_permalink).with('personal').and_return category
      end

      context "when the category has no keywords" do
        let(:keywords) { nil }
        it 'should be empty' do
          get 'show', :id => 'personal'
          assigns(:keywords).should eq ""
        end
      end

      context "when the category has no keywords" do
        let(:keywords) { 'some, keywords' }
        it 'should contain the keywords' do
          get 'show', :id => 'personal'
          assigns(:keywords).should eq "some, keywords"
        end
      end
    end

    describe "when rendered" do
      render_views

      it 'should have a canonical URL' do
        get 'show', id: 'personal'
        response.should have_selector('head>link[href="http://myblog.net/category/personal/"]')
      end
    end

    it 'should render the atom feed for /articles/category/personal.atom' do
      get 'show', :id => 'personal', :format => 'atom'
      response.should render_template('articles/index_atom_feed')
      @layouts.keys.compact.should be_empty
    end

    it 'should render the rss feed for /articles/category/personal.rss' do
      get 'show', :id => 'personal', :format => 'rss'
      response.should render_template('articles/index_rss_feed')
      @layouts.keys.compact.should be_empty
    end
  end

  describe "#show with a non-existent category" do
    before do
      blog = stub_model(Blog, base_url: "http://myblog.net", theme: "typographic", use_canonical_url: true)
      Blog.stub(:default) { blog }
      Trigger.stub(:fire) { }
    end

    it 'should raise ActiveRecord::RecordNotFound' do
      Category.should_receive(:find_by_permalink).with('foo').and_raise(ActiveRecord::RecordNotFound)
      lambda do
        get 'show', :id => 'foo'
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'empty category life-on-mars' do
    it 'should redirect to home when the category is empty' do
      FactoryGirl.create(:blog)
      FactoryGirl.create(:category, :permalink => 'life-on-mars')
      get 'show', :id => 'life-on-mars'
      response.status.should == 301
      response.should redirect_to(Blog.default.base_url)
    end
  end

  describe "password protected article" do
    render_views

    it 'should be password protected when shown in category' do
      FactoryGirl.create(:blog)
      cat = FactoryGirl.create(:category, :permalink => 'personal')
      cat.articles << FactoryGirl.create(:article, :password => 'my_super_pass')
      cat.save!

      get 'show', id: 'personal'

      assert_tag tag: "input", attributes: { id: "article_password" }
    end
  end
end
