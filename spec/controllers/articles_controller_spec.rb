require File.dirname(__FILE__) + '/../spec_helper'

class Content
  def self.find_last_posted
    find(:first, :conditions => ['created_at < ?', Time.now],
         :order => 'created_at DESC')
  end
end

describe 'ArticlesController' do
  controller_name :articles
  fixtures(:contents, :feedback, :categories, :blogs, :users, :categorizations,
           :text_filters, :articles_tags, :tags)

  before(:each) do
    IPSocket.stub!(:getaddress).and_return do
      raise SocketError.new("getaddrinfo: Name or service not known")
    end
  end

  it 'can get a category when permalink == name' do
    get 'category', :id => 'software'

    assigns[:page_title].should == 'category software'
    response.should render_template('index')
  end

  it 'can get a category index when permalink != name' do
    get 'category', :id => 'weird-permalink'

    assigns[:page_title].should == "category weird-permalink"
    response.should render_template('index')
  end

  it 'can get an empty category' do
    get 'category', :id => 'life-on-mars'
    response.should render_template('error')
    assigns[:message].should == "Can't find posts with category 'life-on-mars'"
  end


  it 'index' do
    get 'index'
    response.should render_template(:index)
    assigns[:pages].should_not be_nil
    assigns[:articles].should_not be_nil
  end
end
