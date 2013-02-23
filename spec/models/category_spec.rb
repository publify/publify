require 'spec_helper'

describe Category do
  before(:each) { FactoryGirl.create(:blog) }

  describe "permalink" do
    it "return link with category and name" do
      category = FactoryGirl.build(:category, permalink: 'software')
      category.permalink_url.should eq 'http://myblog.net/category/software'
    end
  end

  describe "published_articles" do
    it "should know published_articles" do
      c = FactoryGirl.create(:category, :permalink => 'Ubbercool')
      FactoryGirl.create(:article, :categories => [c])
      FactoryGirl.create(:article, :categories => [c], :published_at => nil, :published => false, :state => 'draft')
      c.articles.size.should == 2
      c.published_articles.size.should == 1
    end
  end

  describe "permalink" do
    it "empty permalink should be converted" do
      c = FactoryGirl.create(:category, name: "test 1", permalink: nil)
      c.permalink.should eq "test-1"
    end

    it "category with permalink should not have permalink generated" do
      c = FactoryGirl.build(:category, name: "Test 2", permalink: "yeah-nice-one")
      c.permalink.should eq "yeah-nice-one"
    end
  end

  describe 'Category.find_all_with_article_counters' do
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

  describe "find_by_permalink" do
    it "return first that match with this permalink" do
      cat = FactoryGirl.create(:category, permalink: "a-permalink")
      Category.find_by_permalink("a-permalink").should eq cat
    end
  end

end

__END__
xm.loc item.permalink_url
xm.lastmod item.updated_at.xmlschema
xm.priority 0.8


category
xm.loc item.permalink_url
i  xm.lastmod collection_lastmod(item)
