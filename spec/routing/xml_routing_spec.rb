require 'spec_helper'

describe XmlController do
  describe "routing" do
    it "recognizes and generates #articlerss" do
      { :get => "/xml/articlerss/1/feed.xml"}.should route_to(:controller => "xml", :action => "articlerss", :id => "1")
    end

    it "recognizes and generates #commentrss" do
      { :get => "/xml/commentrss/feed.xml"}.should route_to(:controller => "xml", :action => "commentrss")
    end

    it "recognizes and generates #trackbackrss" do
      { :get => "/xml/trackbackrss/feed.xml"}.should route_to(:controller => "xml", :action => "trackbackrss")
    end

    it "recognizes and generates #rsd" do
      { :get => "/xml/rsd"}.should route_to(:controller => "xml", :action => "rsd")
    end

    it "recognizes and generates #feed" do
      { :get => "/xml/atom/feed.xml"}.should route_to(:controller => "xml", :action => "feed", :type => "feed", :format => "atom")
    end

    it "recognizes and generates #feed with a custom type" do
      { :get => "/xml/atom/comments/feed.xml"}.should route_to(:controller => "xml", :action => "feed", :format => "atom", :type => "comments")
    end

    it "recognizes and generates #feed with a custom type and an id" do
      { :get => "/xml/atom/comments/1/feed.xml"}.should route_to(:controller => "xml", :action => "feed", :format => "atom", :type => "comments", :id => "1")
    end

    it "recognizes and generates #feed with rss type" do
      { :get => "/xml/rss"}.should route_to(:controller => "xml", :action => "feed", :type => "feed", :format => "rss")
    end

    it "recognizes and generates #feed without format" do
      { :get => "/xml/feed"}.should route_to(:controller => "xml", :action => "feed")
    end

    it "recognizes and generates #feed with sitemap type" do
      { :get => "/sitemap.xml"}.should route_to(:controller => "xml", :action => "feed", :type => "sitemap", :format => "googlesitemap")
    end
  end
end
