require 'spec_helper'

describe "articles/read.html.erb" do
  with_each_theme do |theme, view_path|
    describe theme ? "with theme #{theme}" : "without a theme" do
      before(:each) do
        @controller.view_paths.unshift(view_path) if theme

        # we do not want to test article links and such
        view.stub(:article_links) { "" }
        view.stub(:category_links) { "" }
        view.stub(:tag_links) { "" }

        Factory(:blog, :comment_text_filter => 'textile')
        @controller.action_name = "redirect"

        Factory(:comment, :article => article, :body => 'Comment body _italic_ *bold*')
        Factory(:comment, :article => article, :body => 'Hello foo@bar.com http://www.bar.com')

        assign(:article, article)
        render
      end

      let(:article) { Factory(:article, :body => 'body', :extended => 'extended content') }

      it "should not have too many paragraph marks around body" do
        rendered.should have_selector("p", :content => "body")
        rendered.should_not have_selector("p>p", :content => "body")
      end

      it "should not have too many paragraph marks around extended contents" do
        rendered.should have_selector("p", :content => "extended content")
        rendered.should_not have_selector("p>p", :content => "extended content")
      end

      it "should not have too many paragraph marks around comment contents" do
        rendered.should have_selector("p>em", :content => "italic")
        rendered.should have_selector("p>strong", :content => "bold")
        rendered.should_not have_selector("p>p>em", :content => "italic")
      end

      it "should automatically add links" do
        rendered.should have_selector("a", :href => "mailto:foo@bar.com",
          :content => "foo@bar.com")
        rendered.should have_selector("a", :href=>"http://www.bar.com",
          :content => "http://www.bar.com")
      end
    end
  end
end

