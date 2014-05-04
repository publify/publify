require "spec_helper"
require './lib/title.rb'

describe Title do
  describe "a single entry exists" do
    before(:each) do 
      blog = create(:blog)
      blog.permalink_format = "/%year%/%month%/%day%/%title%"
      FactoryGirl.create(:article, title: 'article-6', 
                         permalink: "article-6", 
                         published_at: Time.utc(2004, 6, 1))
    end

    it 'returns the title with a -2 added if there is a previous entry' do
      article = FactoryGirl.build(:article, title: 'article-6', 
                                   permalink: "article-6", 
                                   published_at: Time.utc(2004, 6, 1))
      permalink = Title.dedup(article)
      permalink.should == "article-6-2"
    end

    it 'does not add a number if they are published on a different day' do
      article = FactoryGirl.build(:article, title: 'article-6', 
                                   permalink: "article-6", 
                                   published_at: Time.utc(2004, 6, 2))
      permalink = Title.dedup(article)
      permalink.should == "article-6"
    end

    it "returns the title with a -3 addded if there two previous entries" do
      FactoryGirl.create(:article, title: 'article-6', 
                         permalink: "article-6-2-2", 
                         published_at: Time.utc(2004, 6, 1))

      article = FactoryGirl.build(:article, title: 'article-6', 
                                   permalink: "article-6", 
                                   published_at: Time.utc(2004, 6, 1))
      permalink = Title.dedup(article)
      permalink.should == "article-6-3"
    end
  end
end
