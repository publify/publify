require 'spec_helper'

with_each_theme do |theme, view_path|
  describe "#{view_path}/articles/index" do
    before(:each) do
      @controller.view_paths.unshift(view_path) if theme
      @layout = theme ? "#{view_path}/../layouts/default" : false
    end

    context "normally" do
      before(:each) do
        @controller.action_name = "index"
        @controller.request.path_parameters["controller"] = "articles"
        assign(:articles, Article.paginate(:all, :page => 2, :per_page => 4))
        if @layout
          render :file => "articles/index", :layout => @layout
        else
          render :file => "articles/index"
        end
      end

      subject { rendered }

      it "should not have pagination link to page 2 without q param" do
        should_not have_selector("a", :href => "/page/2")
      end

      it "should have pagination link to page 1 without q param if on page 2" do
        should have_selector("a", :href=> "/page/1")
      end

      it "should not have too many paragraph marks around body" do
        should have_selector("p", :content => "body")
        should_not have_selector("p>p", :content => "body")
      end

      it "should not have div nested inside p" do
        should_not have_selector("p>div")
      end

      it "should not have extra escaped html" do
        should_not =~ /&lt;/
        should_not =~ /&gt;/
        should_not =~ /&amp;/
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
        if @layout
          render :file => "articles/index", :layout => @layout
        else
          render :file => "articles/index"
        end
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
