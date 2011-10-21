require 'spec_helper'

describe "articles/read.html.erb" do
  [nil, 'theme', 'view_path'].each do |theme|
    describe theme ? "with theme #{theme}" : "without a theme" do
      before(:each) do
        view_path = ''
        Dir.new(File.join(::Rails.root.to_s, "themes")).each do |theme|
          next if theme =~ /\.\.?/
            view_path = "#{::Rails.root.to_s}/themes/#{theme}/views"
          if File.exists?("#{::Rails.root.to_s}/themes/#{theme}/helpers/theme_helper.rb")
            require "#{::Rails.root.to_s}/themes/#{theme}/helpers/theme_helper.rb"
          end
        end

        @controller.view_paths.unshift(view_path) if theme

        # we do not want to test article links and such
        view.stub(:article_links) { "" }
        view.stub(:category_links) { "" }
        view.stub(:tag_links) { "" }

        view.stub(:display_date_and_time) {|dt| dt.to_s}

        blog = stub_default_blog
        blog.comment_text_filter = Factory.create(:textile).name
        @controller.action_name = "redirect"

        #article = stub_full_article(Time.now - 2.hours)
        time = Time.now - 2.hours
        article = Factory.create(:article, :published_at => time, :updated_at => time, :created_at => time, :text_filter => Factory.create(:textile))
        article.body = 'body'
        article.extended = 'extended content'

        @c1 = Factory.create(:comment, :created_at => Time.now - 2.seconds, :body => 'Comment body _italic_ *bold*')
        @c2 = Factory.create(:comment, :created_at => Time.now, :body => 'Hello foo@bar.com http://www.bar.com')

        article.stub(:published_comments) { [@c1, @c2] }

        text_filter = Factory.create(:textile)
        TextFilter.stub(:find_by_name) { text_filter }

        assign(:article, article)
        render
      end

      subject { rendered }

      it {should have_selector("p", :content => "body") }
      it {should_not have_selector("p>p", :content => "body")}
      it {should have_selector("p", :content => "extended content")}
      it {should_not have_selector("p>p", :content => "extended content")}
      it {should have_selector("p>em", :content => "italic")}
      it {should have_selector("p>strong", :content => "bold")}
      it {should_not have_selector("p>p>em", :content => "italic")}
      it {should have_selector("a", :href => "mailto:foo@bar.com", :content => "foo@bar.com")}
      it {should have_selector("a", :href=>"http://www.bar.com", :content => "http://www.bar.com")}
      it {should =~ /#{@c1.created_at.to_s}/}
        it {should =~ /#{@c2.created_at.to_s}/}
    end
  end
end

