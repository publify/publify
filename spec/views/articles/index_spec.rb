require 'spec_helper'

describe "articles/index.html.erb" do
with_each_theme do |theme, view_path|
  describe theme ? "with theme #{theme}" : "without a theme" do
    before(:each) do
      @controller.view_paths.unshift(view_path) if theme
      build_stubbed :blog
    end

    context "normally" do
      before(:each) do
        articles = 2.times.map { build_stubbed(:article, :body => 'body') }
        @controller.action_name = "index"
        @controller.request.path_parameters["controller"] = "articles"
        assign(:articles, stub_pagination(articles))

        render
      end

      subject { rendered }

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

      it "renders the regular article partial twice" do
        view.should render_template(:partial => "articles/_article_content",
                                    :count => 2)
      end

      it "does not render any password forms" do
        view.should_not render_template(:partial => "articles/_password_form")
      end
    end

    context "without search, on page 2" do
      before(:each) do
        articles = 3.times.map { build_stubbed :article }
        @controller.action_name = "index"
        @controller.request.path_parameters["controller"] = "articles"
        assign(:articles, stub_pagination(articles, current_page: 2, per_page: 2))

        render
      end

      subject { rendered }

      it "should not have pagination link to page 2" do
        should_not have_selector("a", :href => "/page/2")
      end

      it "should have pagination link to page 1" do
        should have_selector("a", :href=> "/")
      end
    end

    context "when on page 2 of search" do
      before(:each) do
        articles = 3.times.map { build_stubbed :article }

        @controller.action_name = "search"
        @controller.request.path_parameters["controller"] = "articles"

        params[:q]           = "body"
        params[:page]        = 2
        params[:action]      = 'search'

        assign(:articles, stub_pagination(articles, current_page: 2, per_page: 2))

        render
      end

      it "should not have pagination link to search page 2" do
        rendered.should_not have_selector("a", :href => "/search/body/page/2")
      end

      it "should have pagination link to search page 1" do
        rendered.should have_selector("a", :href => "/search/body")
      end
    end
  end
end
end
