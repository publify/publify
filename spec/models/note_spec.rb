# coding: utf-8
require 'spec_helper'

describe "Testing redirects" do
  it "a new published status gets a redirect" do
    FactoryGirl.create(:blog)
    a = Note.create(:body => "some text", :published => true)
    a.should be_valid
    a.redirects.first.should_not be_nil
    a.redirects.first.to_path.should == a.permalink_url
  end
end

describe "Testing hashtag and @mention replacement in html postprocessing" do
  before(:each) do
    FactoryGirl.create(:blog, :dofollowify => true)
  end

  it "should replace a hashtag with a proper URL to Twitter search" do
    note = FactoryGirl.create(:note, :body => "A test tweet with a #hashtag")
    text = note.html_preprocess(note.body, note.body)
    text.should == "A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a>"
  end  
  
  it "should replace a @mention by a proper URL to the twitter account" do
    note = FactoryGirl.create(:note, :body => "A test tweet with a @mention")
    text = note.html_preprocess(note.body, note.body)
    text.should == "A test tweet with a <a href='https://twitter.com/mention'>@mention</a>"
  end

  it "should replace a http URL by a proper link" do
    note = FactoryGirl.create(:note, :body => "A test tweet with a http://link.com")
    text = note.html_preprocess(note.body, note.body)
    text.should == "A test tweet with a <a href='http://link.com'>http://link.com</a>"
  end

  it "should replace a https URL with a proper link" do
    note = FactoryGirl.create(:note, :body => "A test tweet with a https://link.com")
    text = note.html_preprocess(note.body, note.body)
    text.should == "A test tweet with a <a href='https://link.com'>https://link.com</a>"
  end  
end

describe 'Testing notes scopes' do
  before(:each) do
    FactoryGirl.create(:blog)
    Note.delete_all
  end

  it 'Published scope should not bring unpublished statuses' do
    FactoryGirl.create(:note)
    FactoryGirl.create(:unpublished_note)
    
    notes = Note.published
    notes.count.should == 1
  end

  it 'Published scope should not bring notes published in the future' do
    FactoryGirl.create(:note)
    FactoryGirl.create(:note, published_at: Time.now + 3.days )
    
    notes = Note.published
    notes.count.should == 1
  end
end


describe 'Given the factory :status' do
  before(:each) do
    FactoryGirl.create(:blog)
    @note = FactoryGirl.create(:note)
  end

  describe "#permalink_url" do
    subject { @note.permalink_url }
    it { should == "http://myblog.net/note/#{@note.id}-this-is-a-status" }
  end
  
  it "should give a sanitized title" do
    note = FactoryGirl.build(:note, :body => 'body with accents éèà')
    note.body.to_permalink.should == 'body-with-accents-eea'
  end
end

class Hash
  def except(*keys)
    self.reject { |k,v| keys.include? k.to_sym }
  end

  def only(*keys)
    self.dup.reject { |k, v| !keys.include? k.to_sym }
  end
end

describe 'Given no notes' do
  def valid_attributes
    { :body => 'body'}
  end

  before(:each) do
    Note.delete_all
    @note = Note.new
  end

  it 'An empty note is invalid' do
    @note.should_not be_valid
  end

  it 'A note is valid with a body' do
    @note.attributes = valid_attributes
    @note.should be_valid
  end

  it 'A note is invalid without a body' do
    @note.attributes = valid_attributes.except(:body)
    @note.should_not be_valid
    @note.errors[:body].should == ["can't be blank"]
    @note.body = 'somebody'
    @note.should be_valid
  end
  
  it "should use sanitize title to set note name" do
    @note.attributes = valid_attributes.except(:body)
    @note.body = 'title with accents éèà'
    @note.should be_valid
    @note.save
    @note.permalink.should == "#{@note.id}-title-with-accents-eea"
  end
  
end

describe 'Given a note page' do
  it 'default filter should be fetched from the blog' do
    FactoryGirl.create(:blog)
    @note = Note.new()
    @note.default_text_filter.name.should == Blog.default.text_filter
  end
end

describe "Checking Twitter message length..." do
  it "A twitter message without URL should not be changed" do
    note = FactoryGirl.build(:note, twitter_message: "A message without URL")
    note.instance_eval{ calculate_real_length }.should == 21
  end
  
  it "A twitter message with a short http URL should have its URL expanded to 20 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a short URL http://foo.com")
    note.instance_eval{ calculate_real_length }.should == 47
  end
  
  it "A twitter message with a short https URL should have its URL expanded to 21 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a short URL https://foo.com")
    note.instance_eval{ calculate_real_length }.should == 48
  end

  it "A twitter message with a short https URL should have its URL expanded to 19 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a short URL ftp://foo.com")
    note.instance_eval{ calculate_real_length }.should == 46
  end

  it "A twitter message with a long http URL should have its URL shortened to 20 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a long URL http://foobarsomething.com?blablablablabla")
    note.instance_eval{ calculate_real_length }.should == 46
  end
  
  it "A twitter message with a short https URL should have its URL expanded to 21 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a long URL https://foobarsomething.com?blablablablabla")
    note.instance_eval{ calculate_real_length }.should == 47
  end

  it "A twitter message with a short https URL should have its URL expanded to 19 chars" do
    note = FactoryGirl.build(:note, twitter_message: "A message with a long URL ftp://foobarsomething.com?blablablablabla")
    note.instance_eval{ calculate_real_length }.should == 45
  end
end 

describe 'Pushing a note to Twitter' do
  before :each do
    Blog.delete_all
  end

  it 'A note without push to twitter defined should not push to Twitter' do
    FactoryGirl.create(:blog)
    note = FactoryGirl.build(:note, :push_to_twitter => 0)
    note.send_to_twitter.should == false
  end
  
  it 'a non configured blog and non configured user should not send a note to Twitter' do
    FactoryGirl.create(:blog)
    note = FactoryGirl.create(:note)
    note.send_to_twitter.should == false
  end

  it 'a configured blog and non configured user should not send a note to Twitter' do
    FactoryGirl.build(:blog, twitter_consumer_key: "12345", twitter_consumer_secret: "67890")
    user = FactoryGirl.build(:user)
    note = FactoryGirl.build(:note, user: user)
    note.send_to_twitter.should == false
  end
  
  it 'a non configured blog and a configured user should not send a note to Twitter' do
    FactoryGirl.build(:blog)
    user = FactoryGirl.build(:user, twitter_oauth_token: "12345", twitter_oauth_token_secret: "67890")
    note = FactoryGirl.build(:note, user: user)
    note.send_to_twitter.should == false
  end

  it 'a configured blog and a configured user should send a note to Twitter' do
    FactoryGirl.build(:blog, twitter_consumer_key: "12345", twitter_consumer_secret: "67890")
    user = FactoryGirl.build(:user, twitter_oauth_token: "12345", twitter_oauth_token_secret: "67890")
    note = FactoryGirl.build(:note, user: user)
    pending "Need to find a way to fake the Twitter API behavior"
    # status.send_to_twitter.should == false
  end
end

