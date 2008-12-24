require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ArticlesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "articles", :action => "index").should == "/"
    end
    
    it "should map #index with rss format" do
      route_for(:controller => "articles", :action => "index", :format => "rss").should == "/articles.rss"
    end
    
    it "should map #index with atom format" do
      route_for(:controller => "articles", :action => "index", :format => "atom").should == "/articles.atom"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/").should == {:controller => "articles", :action => "index"}
    end
    
    it "should generate params for #index with rss format" do
      params_from(:get, "/articles.rss").should == {:controller => "articles", :action => "index", :format => "rss"}
    end
    
    it "should generate params for #index with atom format" do
      params_from(:get, "/articles.atom").should == {:controller => "articles", :action => "index", :format => "atom"}
    end
  end
end
