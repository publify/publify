require 'spec_helper'

describe 'Given the results of Category.find_all_with_article_counters' do
  before(:each) { @cats = Category.find_all_with_article_counters }

  it "Categories should be sorted by category.position" do
    @cats.should == @cats.sort_by { |c| c.position }
  end

  it "Counts should be correct" do
    @cats.each do |cat|
      cat.article_counter.should == cat.published_articles.size
    end
  end
end

describe "Category" do
  it "should know published_articles" do
    FactoryGirl.create(:blog)
    c = FactoryGirl.create(:category, :permalink => 'Ubbercool')
    FactoryGirl.create(:article, :categories => [c])
    FactoryGirl.create(:article, :categories => [c], :published_at => nil, :published => false, :state => 'draft')
    c.articles.size.should == 2
    c.published_articles.size.should == 1
  end
  
  it "empty permalink should be converted" do
    FactoryGirl.create(:blog)
    c = Category.create(:name => "test 1")
    c.permalink.should == "test-1"
  end
  
  it "category with permalink should not have permalink generated" do
    FactoryGirl.create(:blog)
    c = Category.create(:name => "Test 2", :permalink => "yeah-nice-one")
    c.permalink.should == "yeah-nice-one"
  end
  
end

describe Category do
  describe "permalink" do
    before(:each) { FactoryGirl.create(:blog) }
    subject { FactoryGirl.create(:category, :permalink => 'software').permalink_url }
    it { should == 'http://myblog.net/category/software' }
  end
end


