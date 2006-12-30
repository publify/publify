require File.dirname(__FILE__) + '/../spec_helper'

class Content
  def self.find_last_posted
    find(:first, :conditions => ['created_at < ?', Time.now],
         :order => 'created_at DESC')
  end
end

context 'ArticlesController' do
  controller_name :articles
  fixtures(:contents, :feedback, :categories, :blogs, :users, :categorizations,
           :text_filters, :articles_tags, :tags)

  setup do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
  end

  specify 'can get a category when permalink == name' do
    get 'category', :id => 'software'

    controller.should_render :action => 'index'
    assigns[:page_title].should == 'category software'
  end

  specify 'can get a category index when permalink != name' do
    get 'category', :id => 'weird-permalink'
    controller.should_render :action => 'index'
    assigns[:page_title].should == "category weird-permalink"
  end

  specify 'can get an empty category' do
    get 'category', :id => 'life-on-mars'
    controller.should_render :action => 'error'
    assigns[:message].should == "Can't find posts with category 'life-on-mars'"
  end


  specify 'index' do
    controller.should_render :index
    get 'index'
    assigns[:pages].should_not_be_nil
    assigns[:articles].should_not_be_nil
  end
end
