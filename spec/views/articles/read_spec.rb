require File.dirname(__FILE__) + '/../../spec_helper'

with_each_theme do |theme, view_path|
  describe "#{view_path}/articles/read" do
    before(:each) do
      @controller.view_paths.unshift(view_path) if theme
      # we do not want to test article links and such
      ActionView::Base.class_eval do
        def article_links(article)
          ""
        end
        alias :category_links :article_links
        alias :tag_links :article_links
      end
    end
  
    context "applying text filters" do
      before(:each) do
        @controller.action_name = "redirect"
        assigns[:article] = contents('article1')
        render "articles/read"
      end
    
      it "should not have too many paragraph marks around body" do
        response.should have_tag("p", "body")
        response.should_not have_tag("p>p", "body")
      end

      it "should not have too many paragraph marks around extended contents" do
        response.should have_tag("p", "extended content")
        response.should_not have_tag("p>p", "extended content")
      end
    end

    context "formatting comments" do
      before(:each) do
        Blog.default.comment_text_filter = 'textile'
        @controller.action_name = "read"
        assigns[:article] = contents('article1')
        render "articles/read"
      end
    
      it "should not have too many paragraph marks around comment contents" do
        response.should have_tag("p>em", "italic")
        response.should have_tag("p>strong", "bold")
        response.should_not have_tag("p>p>em", "italic")
      end
    end

    context "formatting comments with bare links" do
      before(:each) do
        Blog.default.comment_text_filter = 'textile'
        @controller.action_name = "read"
        assigns[:article] = contents('article3')
        render "articles/read"
      end
    
      it "should automatically add links" do
	response.should have_tag("a[href=mailto:foo@bar.com]",
				 "foo@bar.com")
        response.should have_tag("a[href=http://www.bar.com]",
				 "http://www.bar.com")
      end
    end
  end
end

