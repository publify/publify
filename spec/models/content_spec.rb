# coding: utf-8
require 'spec_helper'

describe Content do
  before do
    @blog = stub_model(Blog)
    Blog.stub(:default) { @blog }
    @content = Content.create
  end

  describe "#short_url" do
    before do
      @content.published = true
      @content.redirects.build :from_path => "foo", :to_path => "bar"
      @content.save
    end

    describe "normally" do
      before do
        @blog.stub(:base_url) { "http://myblog.net" }
      end

      it "returns the blog's base url combined with the redirection's from path" do
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
end

