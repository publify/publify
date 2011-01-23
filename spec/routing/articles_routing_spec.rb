require 'spec_helper'

describe ArticlesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/" }.should route_to(:controller => "articles", :action => "index")
    end

    it "recognizes and generates #index with rss format" do
      { :get, "/articles.rss" }.should route_to(:controller => "articles", :action => "index", :format => "rss")
    end

    it "recognizes and generates #index with atom format" do
      { :get, "/articles.atom" }.should route_to(:controller => "articles", :action => "index", :format => "atom")
    end
  end

  describe "routing for #redirect action" do
    it 'should split the path into its components' do
      assert_routing "foo/bar/baz", {
        :from => ["foo", "bar", "baz"],
        :controller => 'articles', :action => 'redirect'}
    end

    it 'should route URLs under /articles' do
      assert_routing "articles", {
        :from => ["articles"],
        :controller => 'articles', :action => 'redirect'}
      assert_routing "articles/foo", {
        :from => ["articles", "foo"],
        :controller => 'articles', :action => 'redirect'}
      assert_routing "articles/foo/bar", {
        :from => ["articles", "foo", "bar"],
        :controller => 'articles', :action => 'redirect'}
      assert_routing "articles/foo/bar/baz", {
        :from => ["articles", "foo", "bar", "baz"],
        :controller => 'articles', :action => 'redirect'}
    end
  end
end
