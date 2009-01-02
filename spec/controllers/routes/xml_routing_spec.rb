require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe XmlController do
  describe "route generation" do
    it "should map #itunes" do
      route_for(:controller => "xml", :action => "itunes").should == "/xml/itunes/feed.xml"
    end
    
    it "should map #articlerss" do
      route_for(:controller => "xml", :action => "articlerss", :id => "1").should == "/xml/articlerss/1/feed.xml"
    end
    
    it "should map #commentrss" do
      route_for(:controller => "xml", :action => "commentrss").should == "/xml/commentrss/feed.xml"
    end
    
    it "should map #trackbackrss" do
      route_for(:controller => "xml", :action => "trackbackrss").should == "/xml/trackbackrss/feed.xml"
    end
    
    it "should map #feed" do
      route_for(:controller => "xml", :action => "feed", :type => "feed", :format => "atom").should == "/xml/atom/feed.xml"
    end
    
    it "should map #feed with a custom type" do
      route_for(:controller => "xml", :action => "feed", :format => "atom", :type => "comments").should == "/xml/atom/comments/feed.xml"
    end
    
    it "should map #feed with a custom type and an id" do
      route_for(:controller => "xml", :action => "feed", :format => "atom", :type => "comments", :id => "1").should == "/xml/atom/comments/1/feed.xml"
    end
    
    it "should map #feed with rss type" do
      route_for(:controller => "xml", :action => "feed", :type => "feed", :format => "rss").should == "/xml/rss"
    end
    
    it "should map #feed with sitemap type" do
      route_for(:controller => "xml", :action => "feed", :type => "sitemap", :format => "googlesitemap").should == "/sitemap.xml"
    end
  end

  describe "route recognition" do
    it "should generate params for #itunes" do
      params_from(:get, "/xml/itunes/feed.xml").should == {:controller => "xml", :action => "itunes"}
    end
    
    it "should generate params for #articlerss" do
      params_from(:get, "/xml/articlerss/1/feed.xml").should == {:controller => "xml", :action => "articlerss", :id => "1"}
    end
    
    it "should generate params for #commentrss" do
      params_from(:get, "/xml/commentrss/feed.xml").should == {:controller => "xml", :action => "commentrss"}
    end
    
    it "should generate params for #trackbackrss" do
      params_from(:get, "/xml/trackbackrss/feed.xml").should == {:controller => "xml", :action => "trackbackrss"}
    end
    
    it "should generate params for #feed" do
      params_from(:get, "/xml/atom/feed.xml").should == {:controller => "xml", :action => "feed", :type => "feed", :format => "atom"}
    end
    
    it "should generate params for #feed with a custom type" do
      params_from(:get, "/xml/atom/comments/feed.xml").should == {:controller => "xml", :action => "feed", :format => "atom", :type => "comments"}
    end
    
    it "should generate params for #feed with a custom type and an id" do
      params_from(:get, "/xml/atom/comments/1/feed.xml").should == {:controller => "xml", :action => "feed", :format => "atom", :type => "comments", :id => "1"}
    end
    
    it "should generate params for #feed with rss type" do
      params_from(:get, "/xml/rss").should == {:controller => "xml", :action => "feed", :type => "feed", :format => "rss"}
    end
    
    it "should generate params for #feed with sitemap type" do
      params_from(:get, "/sitemap.xml").should == {:controller => "xml", :action => "feed", :type => "sitemap", :format => "googlesitemap"}
    end
  end
end
