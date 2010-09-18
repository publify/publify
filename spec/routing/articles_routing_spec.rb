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
end
