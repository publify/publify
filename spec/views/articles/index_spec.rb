require 'spec_helper'

with_each_theme do |theme, view_path|
  describe "#{view_path}/articles/index" do
    before(:each) do
      @controller.view_paths.unshift(view_path) if theme
      # we only want to test pagination links
      ActionView::Base.class_eval do
        def article_links(article)
          ""
        end
        alias :category_links :article_links
        alias :tag_links :article_links
      end
    end

    context "normally" do
      before(:each) do
        @controller.action_name = "index"
        @controller.request.path_parameters["controller"] = "articles"
        assign(:articles, Article.paginate(:all, :page => 2, :per_page => 4))
        render :file => "articles/index"
      end

      it "should not have pagination link to page 2 without q param" do
        rendered.should_not have_selector("a", :href => "/page/2")
      end

      it "should have pagination link to page 1 without q param if on page 2" do
        rendered.should have_selector("a", :href=> "/page/1")
      end

      it "should not have too many paragraph marks around body" do
        rendered.should have_selector("p", :content => "body")
        rendered.should_not have_selector("p>p", :content => "body")
      end

      it "should not have div nested inside p" do
        rendered.should_not have_selector("p>div")
      end
    end

    context "when on page 2 of search" do
      before(:each) do
        @controller.action_name = "search"
        @controller.request.path_parameters["controller"] = "articles"
        params[:q]           = "body"
        params[:page]        = 2
        params[:action]      = 'search'
        assign(:articles, Blog.default.articles_matching(params[:q], :page => 2, :per_page => 4))
        render :file => "articles/index"
      end

      it "should not have pagination link to search page 2" do
        rendered.should_not have_selector("a", :href => "/search/body/page/2")
      end

      it "should have pagination link to search page 1" do
        rendered.should have_selector("a", :href => "/search/body/page/1")
      end
    end
  end
end
