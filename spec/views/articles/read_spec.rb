require File.dirname(__FILE__) + '/../../spec_helper'

# test standard view and all themes
[ nil, "dirtylicious", "scribbish", "standard_issue", "typographic" ].each do |theme|
  view_path = theme ? "#{RAILS_ROOT}/themes/#{theme}/views" : "" 
  describe "#{view_path}/articles/read" do
    before(:each) do
      @controller.view_paths = [ "#{RAILS_ROOT}/themes/#{theme}/views" ] if theme
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
        @controller.action_name = "read"
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
  end
end

