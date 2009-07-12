require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorsController do
  controller_name :authors
  Article.delete_all

  integrate_views

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
    controller.send(:reset_blog_ids)
  end

  describe 'show action' do
    before :each do
      get 'show', :id => 'tobi'
    end

    it 'should be render template index' do
      response.should render_template(:show)
    end

    it 'should assigns articles' do
      assigns[:author].should_not be_nil
    end

    it 'should have good link feed rss' do
      response.should have_tag('head>link[href=?]','http://test.host/author/tobi.rss')
    end

    it 'should have good link feed atom' do
      response.should have_tag('head>link[href=?]','http://test.host/author/tobi.atom')
    end
  end

  specify "/author/tobi.atom => an atom feed" do
    get 'show', :id => 'tobi', :format => 'atom'
    response.should be_success
    response.should render_template("articles/_atom_feed")
  end

  specify "/author/tobi.rss => a rss feed" do
    get 'show', :id => 'tobi', :format => 'rss'
    response.should be_success
    response.should render_template("articles/_rss20_feed")
    response.should have_tag('link', 'http://myblog.net')
  end
end
