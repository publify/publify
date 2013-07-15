# coding: utf-8
require 'spec_helper'

describe "Testing redirects" do
  it "a new published status gets a redirect" do
    FactoryGirl.create(:blog)
    a = Status.create(:body => "some text", :published => true)
    a.should be_valid
    a.redirects.first.should_not be_nil
    a.redirects.first.to_path.should == a.permalink_url
  end
end

describe 'Given the factory :status' do
  before(:each) do
    FactoryGirl.create(:blog)
    @status = FactoryGirl.create(:status)
  end

  describe "#permalink_url" do
    subject { @status.permalink_url }
    it { should == "http://myblog.net/st/#{@status.id}-this-is-a-status" }
  end
  
  it "should give a sanitized title" do
    status = FactoryGirl.build(:status, :body => 'body with accents éèà')
    status.body.to_permalink.should == 'body-with-accents-eea'
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

describe 'Given no statuses' do
  def valid_attributes
    { :body => 'body'}
  end

  before(:each) do
    Status.delete_all
    @status = Status.new
  end

  it 'An empty status is invalid' do
    @status.should_not be_valid
  end

  it 'A status is valid with a body' do
    @status.attributes = valid_attributes
    @status.should be_valid
  end

  it 'A status is invalid without a body' do
    @status.attributes = valid_attributes.except(:body)
    @status.should_not be_valid
    @status.errors[:body].should == ["can't be blank"]
    @status.body = 'somebody'
    @status.should be_valid
  end
  
  it "should use sanitize title to set status name" do
    @status.attributes = valid_attributes.except(:body)
    @status.body = 'title with accents éèà'
    @status.should be_valid
    @status.save
    @status.permalink.should == "#{@status.id}-title-with-accents-eea"
  end
  
end

describe 'Given a status page' do
  it 'default filter should be fetched from the blog' do
    FactoryGirl.create(:blog)
    @status = Status.new()
    @status.default_text_filter.name.should == Blog.default.text_filter
  end
end
