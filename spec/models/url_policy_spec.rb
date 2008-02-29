require File.dirname(__FILE__) + '/../spec_helper'

describe UrlPolicy do
  it "should have an instance" do
    UrlPolicy.instance.should_not be_nil
  end

  it "should know the default route" do
    UrlPolicy.instance.url_for(:controller => 'articles', :action => 'index').should == '/'
  end

  it "#url_for(contents(:article3)) should == /articles/2004/06/01/article-3" do
    UrlPolicy.instance.url_for(contents(:article3)).should == '/articles/2004/06/01/article-3'
  end

  it "#url_for(<comment on article 3>).should == /articles/2004/06/01/article-3/comments/#\{comment.guid}" do
    article = contents(:article3)
    comment = article.comments.build(:author => 'Piers Cawley', :body => "body")
    comment.save(false)
    UrlPolicy.instance.url_for(comment).should == "/articles/2004/06/01/article-3/comments/#{comment.guid}"
  end

  describe "(for a trackback)" do
    before(:each) do
      @article = contents(:article3)
      @trackback = @article.trackbacks.build(:title => 'Foo', :excerpt => 'bar',
                                             :url => 'http://empty.cabi.net/')
    end

    it "#url_for(<trackback on article 3>).should == /articles/2004/06/01/article-3/comments/#\{trackback.guid}" do
      @trackback.save(false)
      UrlPolicy.instance.url_for(@trackback).should ==
        "/articles/2004/06/01/article-3/trackbacks/#{@trackback.guid}"
    end
  end

  it "#url_for(Article.new) should == '/articles/new'" do
    UrlPolicy.instance.url_for(Article.new).should == '/articles/new'
  end

  it "#edit_url_for(contents(:article3)) should == /articles/2004/06/01/article-3/edit" do
    UrlPolicy.instance.edit_url_for(contents(:article3)).should == '/articles/2004/06/01/article-3/edit'
  end

  it "#url_for(Article.new) should == '/articles/new'" do
    UrlPolicy.instance.edit_url_for(Article.new).should == '/articles/new'
  end
end
