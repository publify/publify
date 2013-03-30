# coding: utf-8
require 'spec_helper'

describe Content do
  before do
    @blog = stub_default_blog
  end

  describe "#short_url" do
    before do
      @content = FactoryGirl.build_stubbed :content,
        published: true,
        redirects: [FactoryGirl.build_stubbed(:redirect, :from_path =>
                                            "foo", :to_path => "bar")]
    end

    describe "normally" do
      before do
        @blog.stub(:base_url) { "http://myblog.net" }
      end

      it "returns the blog's base url combined with the redirection's from path" do
        @content.should be_published
        @content.short_url.should == "http://myblog.net/foo"
      end
    end

    describe "when the blog is in a sub-uri" do
      before do
        @blog.stub(:base_url) { "http://myblog.net/blog" }
      end

      it "includes the sub-uri path" do
        @content.short_url.should == "http://myblog.net/blog/foo"
      end
    end
  end

  describe "#text_filter" do
    it "returns nil by default" do
      @content = Content.new
      @content.text_filter.should be_nil
    end
  end

  describe "#really_send_notifications" do
    it "sends notifications to interested users" do
      @content = Content.new
      henri = mock_model(User)
      alice = mock_model(User)

      @content.should_receive(:notify_user_via_email).with henri
      @content.should_receive(:notify_user_via_email).with alice

      @content.should_receive(:interested_users).and_return([henri, alice])

      @content.really_send_notifications
    end
  end

  describe "#function_search_all_posts" do
    it "returns empty array when nil given" do
      Content.function_search_all_posts(nil).should be_empty
    end

    it "returns article that match with searchstring" do
      expected_function = ['searchstring(search_hash[:searchstring])']
      Content.function_search_all_posts({searchstring: 'something'}).should eq expected_function
    end

    it "returns article that match with published_at" do
      expected_function = ['published_at_like(search_hash[:published_at])']
      Content.function_search_all_posts({published_at: '2012-02'}).should eq expected_function
    end

    it "returns article that match with user_id" do
      expected_function = ['user_id(search_hash[:user_id])']
      Content.function_search_all_posts({user_id: '1'}).should eq expected_function
    end

    it "returns article that match with not published" do
      expected_function = ['not_published']
      Content.function_search_all_posts({published: '0'}).should eq expected_function
    end

    it "returns article that match with published" do
      expected_function = ['published']
      Content.function_search_all_posts({published: '1'}).should eq expected_function
    end

  end
end

