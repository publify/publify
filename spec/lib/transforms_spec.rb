# coding: utf-8
require 'spec_helper'

describe String do
  describe "#to_permalink" do
    it 'should build a nice permalink from an accentuated string' do
      "L'été s'ra chaud, l'été s'ra chaud".to_permalink.should == "l-ete-s-ra-chaud-l-ete-s-ra-chaud"
    end
  end
  
  describe "to_url" do
    it "' this is  a sentence ' should give a proper space-less, trimmed URL" do
      " this is  a sentence ".to_url.should == "this-is-a-sentence"
    end
  end
  
  describe "nofollowify" do
    before(:each) {
      Blog.delete_all
      @blog = FactoryGirl.create :blog
    }
    
    it "with dofollowify disabled, links should be nofollowed" do
      @blog.dofollowify = false
      @blog.save
      
      '<a href="http://myblog.net">my blog</a>'.nofollowify.should == '<a href="http://myblog.net" rel="nofollow">my blog</a>'
    end
    
    it "with dofollowify enabled, links should be nofollowed" do
      @blog.dofollowify = true
      @blog.save
      
      '<a href="http://myblog.net">my blog</a>'.nofollowify.should == '<a href="http://myblog.net">my blog</a>'
    end
  end
  
  describe "strip_html" do
    it "should render text only" do
      "<a href='http://myblog.com'>my blog</a>".strip_html.should == "my blog"
    end
    
    it "should not remove a > from a numeric comparison" do
      "5 < 6 > 4".strip_html.should == "5 < 6 > 4"
    end
  end
end

