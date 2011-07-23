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
    end

    context "applying text filters" do
      before(:each) do
        article = Factory(:article, :body => 'body', :excerpt => 'extended content')
        @controller.action_name = "redirect"
        assign(:article, article)
        render
      end

      it "should not have too many paragraph marks around body" do
        rendered.should have_selector("p", :content => "body")
        rendered.should_not have_selector("p>p", :content => "body")
      end

      it "should not have too many paragraph marks around extended contents" do
        rendered.should have_selector("p", :content => "extended content")
        rendered.should_not have_selector("p>p", :content => "extended content")
      end
    end

    context "formatting comments" do
      before(:each) do
        @controller.action_name = "read"
        article = Factory(:article)
        Factory(:comment, :article => article, :body => 'Comment body _italic_ *bold*')
        assign(:article, article)
        render
      end

      it "should not have too many paragraph marks around comment contents" do
        rendered.should have_selector("p>em", :content => "italic")
        rendered.should have_selector("p>strong", :content => "bold")
        rendered.should_not have_selector("p>p>em", :content => "italic")
      end
    end

    context "formatting comments with bare links" do
      before(:each) do
        article = Factory(:article,
          :allow_comments => true,
          :allow_pings => true,
          :permalink => 'article-3',
          :author => 'Tobi',
          :published => true,
          :state => 'published' )
        Factory(:comment,
          :published => true,
          :state => 'ham',
          :status_confirmed => true,
          :article => article,
          :author => 'Foo Bar',
          :body => 'Hello foo@bar.com http://www.bar.com')

        @controller.action_name = "read"
        assign(:article, article)
        render
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
end

