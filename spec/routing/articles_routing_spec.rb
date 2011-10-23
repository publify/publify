require 'spec_helper'

describe ArticlesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/" }.should route_to(:controller => "articles", :action => "index")
    end

    it "recognizes and generates #index with rss format" do
      { :get => "/articles.rss" }.should route_to(:controller => "articles", :action => "index", :format => "rss")
    end

    it "recognizes and generates #index with atom format" do
      { :get => "/articles.atom" }.should route_to(:controller => "articles", :action => "index", :format => "atom")
    end
  end

  describe "routing for #redirect action" do
    it 'picks up any previously undefined path' do
      { :get => "/foobar" }.should route_to(:controller => 'articles',
                                     :action => 'redirect',
                                     :from => 'foobar')
    end

    it 'matches paths with multiple components' do
      { :get => "foo/bar/baz" }.should route_to(:controller => 'articles',
                                                :action => 'redirect',
                                                :from => "foo/bar/baz")
    end

    it 'should route URLs under /articles' do
      { :get => "/articles" }.should route_to(:controller => 'articles',
                                              :action => 'redirect',
                                              :from => "articles")
      { :get => "/articles/foo" }.should route_to(:controller => 'articles',
                                                  :action => 'redirect',
                                                  :from => "articles/foo")
      { :get => "/articles/foo/bar" }.should route_to(:controller => 'articles',
                                                      :action => 'redirect',
                                                      :from => "articles/foo/bar")
      { :get => "/articles/foo/bar/baz" }.should route_to(:controller => 'articles',
                                                          :action => 'redirect',
                                                          :from => "articles/foo/bar/baz")
    end
  end
end
