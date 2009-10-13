require File.dirname(__FILE__) + '/../spec_helper'

class Content
  def self.find_last_posted
    find(:first, :conditions => ['created_at < ?', Time.now],
         :order => 'created_at DESC')
  end
end

describe 'PreviewsController' do
  controller_name :previews
  Article.delete_all

  integrate_views

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
    controller.send(:reset_blog_ids)
  end

  describe 'index action' do
    before :each do
      get :index, :id => 1
    end

    it 'should be render template /articles/read' do
      response.should render_template('/articles/read')
    end
  end
end
