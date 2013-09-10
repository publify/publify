require 'spec_helper'

describe "articles/read.html.erb" do
  let!(:blog) { create(:blog, comment_text_filter: 'textile') }

  with_each_theme do |theme, view_path|
    describe theme ? "with theme #{theme}" : "without a theme" do
      before(:each) do
        @controller.view_paths.unshift(view_path) if theme
        # we do not want to test article links and such
        view.stub(:article_links) { "" }
        view.stub(:category_links) { "" }
        view.stub(:tag_links) { "" }
        view.stub(:display_date_and_time) {|dt| dt.to_s}
        @controller.action_name = "redirect"

        now = DateTime.new(2013,2,21,15,45)
        article = create(:article, published_at: now, body: 'body', extended: 'extended content', allow_comments: false)

        @c1 = create(:comment, created_at: now + 1.hour, body: 'Comment body _italic_ *bold*', article: article, published: true)
        @c2 = create(:comment, created_at: now + 18.minutes, body: 'Hello foo@bar.com http://www.bar.com', article: article, published: true)

        text_filter = FactoryGirl.build(:textile)
        TextFilter.stub(:find_by_name) { text_filter }

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

      it "should show the comment creation times in the comment list" do
        rendered.should =~ /#{@c1.created_at.to_s}/
        rendered.should =~ /#{@c2.created_at.to_s}/
      end
    end
  end
end

